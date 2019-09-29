package PRC::GitHub;
use namespace::autoclean;

use PRC::Constants;
use PRC::Secrets;
use LWP::UserAgent;
use JSON::XS;
use YAML qw/LoadFile/;

=encoding utf8

=head1 NAME

PRC::GitHub - A Quick Library for GitHub calls

=head1 DESCRIPTION

This is a library to abstract GitHub calls, both POST and GET.
This library can use some optimization, but I avoided doing so for now.
Ideas: Don't create ua for each call.

See https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/
for GitHub's documentation on Authorizing OAuth Apps.

Authorizing an OAuth app on GitHub requires having a verified email address \o/
Good call GitHub. Good call.

=head1 METHODS

=head2 authenticate_url

  $c->response->redirect(PRC::GitHub->authenticate_url);
  $c->detach;

Returns URL for GitHub authentication. Puts client_id in.

=cut

sub authenticate_url {
  my ($self) = @_;
  my $client_id = PRC::Secrets->client_id;
  return "https://github.com/login/oauth/authorize?scope=user%3Aemail&client_id=$client_id";
}

=head2 access_token

  my $token = PRC::GitHub->access_token('code');

Makes a POST to oauth/access_token and returns access_token.
If it errors, returns undef.

=cut

sub access_token {
  my ($self,$code) = @_;
  return undef unless $code;

  my $data_post = {
    code          => $code,
    client_id     => PRC::Secrets->client_id,
    client_secret => PRC::Secrets->client_secret,
  };

  my $ua = LWP::UserAgent->new;
  $ua->agent("PullRequestClub/0.1");

  my $req = HTTP::Request->new(POST => 'https://github.com/login/oauth/access_token');
  $req->content_type('application/json');
  $req->header(Accept => 'application/json');
  $req->content(encode_json($data_post));

  my $res = $ua->request($req);
  return undef unless $res->is_success;
  my $data = eval { decode_json($res->content) };
  return undef unless $data;
  return $data->{access_token};
}

=head2 user_data

  my $user_data = PRC::GitHub->user_data('access_token');

Makes a GET to /user, and returns user details in a hashref.
If it errors, returns undef.

=cut

sub user_data {
  my ($self, $token) = @_;
  return undef unless $token;

  my $ua = LWP::UserAgent->new;
  $ua->agent("PullRequestClub/0.1");

  my $req = HTTP::Request->new(GET => 'https://api.github.com/user');
  $req->header(Authorization => "token $token");
  $req->header(Accept => 'application/vnd.github.v3+json');

  my $res = $ua->request($req);
  return undef unless $res->is_success;
  my $data = eval { decode_json($res->content) };
  return $data;
}

=head2 get_email

  my $github_email = PRC::GitHub->get_email($token);

Makes a GET to /user/emails, returns primary email address
only if it's verified. Returns undef on any error.

=cut

sub get_email {
  my ($self, $token) = @_;
  return undef unless $token;

  my $ua = LWP::UserAgent->new;
  $ua->agent("PullRequestClub/0.1");

  my $req = HTTP::Request->new(GET => 'https://api.github.com/user/emails');
  $req->header(Authorization => "token $token");
  $req->header(Accept => 'application/vnd.github.v3+json');

  my $res = $ua->request($req);
  return undef unless $res->is_success;
  my $data = eval { decode_json($res->content) };
  return undef unless $data && ref $data eq 'ARRAY';

  # "data" is an arrayref of hashes
  # Each item has keys email, primary, verified, visibility.
  # We will prefer ones that is both primary and verified
  # If no such address is found, we will use any verified address.
  # We will use the one that is primary and verified
  my @verified_emails         = grep {$_->{verified}} @$data;
  my @primary_verified_emails = grep {$_->{primary} } @verified_emails;

  # if no primary + verified, then we will look for any verified.
  if (scalar @primary_verified_emails){
    return $primary_verified_emails[0]->{email};
  }
  elsif (scalar @verified_emails){
    return $verified_emails[0]->{email};
  }
  else {
    return undef;
  }
}

=head2 get_repos

  my $repos = PRC::GitHub->get_repos($token);

Makes a GET to /user/repos, return an arrayref.
Excludes forks, archived repos, private repos.
Returns data such that it matches our column names.

=cut

sub get_repos {
  my ($self, $token) = @_;
  return undef unless $token;

  my $ua = LWP::UserAgent->new;
  $ua->agent("PullRequestClub/0.1");

  # Loop through pages
  # TODO look at $res->header('link') that GitHub returns
  my $done = 0;
  my $page = 1;
  my @repos;

  while (!$done){
    my $req = HTTP::Request->new(GET => "https://api.github.com/user/repos?visibility=public&affiliation=owner&page=$page");
    $page++;
    $req->header(Authorization => "token $token");
    $req->header(Accept => 'application/vnd.github.v3+json');

    my $res = $ua->request($req);
    return undef unless $res->is_success;

    my $data = eval { decode_json($res->content) };
    return undef unless $data && ref $data eq 'ARRAY';
    if (scalar @$data){
      # Return empty hashref if we got [{}]
      return [] unless $data->[0]->{id};
    }
    else {
      $done = 1;
      next;
    }

    # "data" is an arrayref of hashes.
    # Filter repos that are archived, forked, or private
    # Keep only a few items that are relevant to us
    my @new_repos =
      map  {{
        github_id                => $_->{id},
        github_name              => $_->{name},
        github_full_name         => $_->{full_name},
        github_language          => $_->{language},
        github_html_url          => $_->{html_url},
        github_pulls_url         => $_->{pulls_url},
        github_events_url        => $_->{events_url},
        github_issues_url        => $_->{issues_url},
        github_issue_events_url  => $_->{issue_events_url},
        github_open_issues_count => $_->{open_issues_count},
        github_stargazers_count  => $_->{stargazers_count},
        gone_missing             => REPO_NOT_GONE_MISSING,
      }}
      grep {
        !$_->{archived} &&
        !$_->{fork}     &&
        !$_->{private}
      } @$data;
    push @repos, @new_repos;
  }

  return \@repos;
}

=head2 confirm_pr

Makes a call to events API and confirms whether assignee
has submitted a PR after assignment date.
Takes in repo, assignee, assignment.
Returns 0 or 1.

=cut

sub confirm_pr {
  my ($self, $repo, $assignee, $assignment) = @_;
  return undef unless $repo && $assignee && $assignment;

  my $ua = LWP::UserAgent->new;
  $ua->agent("PullRequestClub/0.1");

  my $req   = HTTP::Request->new(GET => $repo->github_events_url);
  my $token = $repo->user->github_token;
  $req->header(Authorization => "token $token");
  $req->header(Accept => 'application/vnd.github.v3+json');

  my $res = $ua->request($req);
  return undef unless $res->is_success;

  my $data = eval { decode_json($res->content) };
  return undef unless $data && ref $data eq 'ARRAY';

  my $strp = DateTime::Format::Strptime->new( pattern => '%FT%H:%M:%SZ' );

  my @prs = grep {
    ($_->{type}             eq  'PullRequestEvent'    )  &&
    ($_->{payload}{action}  eq  'opened'              )  &&
    ($_->{actor}{id}        ==  $assignee->github_id  )  &&
    ($strp->parse_datetime($_->{created_at}) > $assignment->create_time)
  } @$data;
  my $pr_count  = scalar @prs;
  my $pr_exists = ($pr_count > 0) ? 1 : 0;

  return $pr_exists;
}

1;
