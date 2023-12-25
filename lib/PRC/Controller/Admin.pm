package PRC::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Constants;
use PRC::Email;
use PRC::Form::Admin::NewAssignmentEmail;
use PRC::Form::Admin::NewFeatureEmail;
use PRC::Form::Admin::OpenReminderEmail;
use PRC::Form::Admin::TimeoutEmail;
use List::Util qw/any first/;

=encoding utf8

=head1 NAME

PRC::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 auto

Before reaching any action in this controller, confirm user has admin powers.
This is currently hardcoded to one user. Everyone else will get a 404.
If we need more admins/roles in future we can build a separate admin/role table.

=cut

sub auto :Private {
  my ($self, $c) = @_;
  my $user = $c->user;

  if ($user && ($user->github_id == 1781335) && ($user->github_login eq 'kyzn')){
    PRC::Event->log($c, "ADMIN_OK");
    $c->stash({ show_admin_navbar => 1, hide_navbar => 1, hide_footer => 1 });
    return 1;
  }

  # Default to 404
  PRC::Event->log($c, "ADMIN_NG");
  $c->response->body('Page not found.');
  $c->response->status(404);
  $c->detach;
}


=head2 /admin

Redirect to /admin/numbers

=cut

sub admin :Path('/admin') :Args(0) {
  my ($self, $c) = @_;
  $c->response->redirect('/admin/numbers',303);
  $c->detach;
}

=head2 /admin/numbers

Basic numbers

=cut

sub numbers :Path('/admin/numbers') :Args(0) {
  my ($self, $c) = @_;

  my @users = $c->model('PRCDB::User')->all;
  my @repos = $c->model('PRCDB::Repo')->all;
  my @orgs  = $c->model('PRCDB::Org')->all;
  my @assignments = $c->model('PRCDB::Assignment')->all;

  my $stats = {
    user_count            => scalar(@users),
    tos_user_count        => scalar(grep {$_->has_accepted_latest_terms} @users),
    deactivated_user      => scalar(grep {$_->is_deactivated && !$_->scheduled_delete_time} @users),
    to_be_deleted_user    => scalar(grep {$_->scheduled_delete_time} @users),
    assignment_user_count => scalar(grep {$_->is_receiving_assignments} @users),
    synced_personal_repos => scalar(grep {$_->last_personal_repo_sync_time} @users),
    synced_org_repos      => scalar(grep {$_->last_org_repo_sync_time} @users),

    all_repo_count => scalar(@repos),
    all_repo_opted => scalar(grep {!$_->gone_missing && $_->accepting_assignees} @repos),
    per_repo_count => scalar(grep {!$_->org_id} @repos),
    per_repo_opted => scalar(grep {!$_->gone_missing && $_->accepting_assignees && !$_->org_id} @repos),
    org_count      => scalar(@orgs),
    org_repo_count => scalar(grep {$_->org_id} @repos),
    org_repo_opted => scalar(grep {!$_->gone_missing && $_->accepting_assignees && $_->org_id} @repos),

    assignment_total   => scalar(@assignments),
    assignment_open    => scalar(grep {$_->status == ASSIGNMENT_OPEN} @assignments),
    assignment_skip    => scalar(grep {$_->status == ASSIGNMENT_SKIPPED} @assignments),
    assignment_deleted => scalar(grep {$_->status == ASSIGNMENT_DELETED} @assignments),
    assignment_timeout => scalar(grep {$_->status == ASSIGNMENT_TIMEOUT} @assignments),
    assignment_done    => scalar(grep {$_->status == ASSIGNMENT_DONE} @assignments),
  };

  PRC::Event->log($c, 'VIEW_ADMIN_NUMBERS');
  $c->stash({
    template   => 'static/html/admin/numbers.html',
    active_tab => 'numbers',
    %$stats,
  });

}

=head2 /admin/events

List events.

=cut

sub events :Path('/admin/events') :Args(0) {
  my ($self, $c) = @_;
  PRC::Event->log($c, 'VIEW_ADMIN_EVENTS');
  my @all_events = reverse $c->model('PRCDB::Event')->all;
  my @logged_in_events  = grep {$_->user_id}  @all_events;
  my @logged_out_events = grep {!$_->user_id} @all_events;

  $c->stash({
    template   => 'static/html/admin/events.html',
    active_tab => 'events',
    events_tab => 'logged_in',
    all_events => \@all_events,
    logged_in_events  => \@logged_in_events,
    logged_out_events => \@logged_out_events,
  });
}

=head2 /admin/users

List users.

=cut

sub users :Path('/admin/users') :Args(0) {
  my ($self, $c) = @_;

  my @users = $c->model('PRCDB::User')->search({},{
    prefetch => ['repos','assignments','orgs'],
  })->all;
  my @assignments = $c->model('PRCDB::Assignment')->all;

  @users = map {{
    user_id             => $_->user_id,
    accepted_latest_tos => $_->has_accepted_latest_terms ? "Y" : "",
    github_login        => $_->github_login,
    deactivation_status => _yymmdd($_->scheduled_delete_time) ||
                           ($_->is_deactivated ? "Y" : ""),

    last_login_time              => _yymmdd($_->last_login_time),

    assignment_status     => $_->is_receiving_assignments ? "Y" : "",
    open_assignment_month => _get_open_assignment_month_sortable($_->assignments),
    assignments_total     => int($_->assignments->count) || '',
    assignments_done      => (scalar(grep {$_->status == ASSIGNMENT_DONE} $_->assignments))    || '',
    assignments_skipped   => (scalar(grep {$_->status == ASSIGNMENT_SKIPPED} $_->assignments)) || '',

    %{_get_repo_counts($_)},

    %{_get_assignee_counts($_,@assignments)},
  }} @users;

  PRC::Event->log($c, 'VIEW_ADMIN_USERS');
  $c->stash({
    users      => \@users,
    template   => 'static/html/admin/users.html',
    active_tab => 'users',
  });

}

=head2 user

=cut

sub user :Path('/admin/user') :Args(1) {
  my ($self, $c, $id) = @_;
  my $user = $c->model('PRCDB::User')->find($id);
  my @taken = $user->assignments_taken;
  my @given = $user->assignments_given;

  PRC::Event->log($c, 'VIEW_ADMIN_USER_ID');
  $c->stash({
    taken       => \@taken,
    given       => \@given,
    template    => 'static/html/admin/user.html',
  });
}

=head2 /admin/assign

List users that are waiting for assignments.
List repos that are waiting for users.

=cut

sub assign :Path('/admin/assign') :Args(0) {
  my ($self, $c) = @_;

  my $user_subquery = $c->model('PRCDB::Assignment')->search({
    'me.user_id' => { '=' => \'sub.user_id' },
    '-or' => [
      { 'sub.status' => ASSIGNMENT_OPEN },
      { 'sub.month'  => { '>=' => \'strftime("%Y-%m",date("now","+3 days"))' }},
    ],
  },{
    from => { sub => 'assignment'},
  })->get_column('sub.assignment_id')->as_query;

  my @users = $c->model('PRCDB::User')->search({
    tos_agree_time => {'>=', LATEST_LEGAL_DATE->ymd},
    is_receiving_assignments => 1,
    is_deactivated => 0,
    'NOT EXISTS' => $user_subquery,
  },{
    prefetch => ['assignments', {'user_langs' => 'lang'}],
  })->all;

  @users = map {{
    user_id             => $_->user_id,
    github_login        => $_->github_login,
    github_email        => $_->github_email,
    langs               => $_->active_user_langs_string,
    %{$_->received_assignment_count},
  }} @users;

  my $repo_subquery = $c->model('PRCDB::Assignment')->search({
    'me.repo_id' => { '=' => \'sub.repo_id' },
    'julianday("now")' => { '<=' => \'julianday(month) + 45' },
  },{
    from => { sub => 'assignment'},
  })->get_column('sub.assignment_id')->as_query;

  my @repos = $c->model('PRCDB::Repo')->search({
    'me.accepting_assignees' => 1,
    'me.gone_missing'        => 0,
    'user.tos_agree_time'    => {'>=', LATEST_LEGAL_DATE->ymd},
    'user.is_deactivated'    => 0,
    'NOT EXISTS'             => $repo_subquery,
  },{
    join     => 'user',
    prefetch => ['assignments','org','user'],
  })->all;

  @repos = map {{
    repo_id   => $_->repo_id,
    user_id   => $_->user_id,
    user_name => $_->user->github_login,
    org_id    => $_->org_id // '-',
    org_name  => ( ($_->org) ? ($_->org->github_login) : ''),
    name      => $_->github_full_name,
    lang      => $_->github_language,
    issues    => $_->github_open_issues_count,
    stars     => $_->github_stargazers_count,
    assignment_count => scalar($_->assignments),
    done_assignment_count => scalar(grep {$_->status_string eq 'Done'} $_->assignments),
  }} @repos;

  PRC::Event->log($c, 'VIEW_ADMIN_ASSIGN');
  $c->stash({
    users      => \@users,
    repos      => \@repos,
    template   => 'static/html/admin/assign.html',
    active_tab => 'assign',
  });

}

=head2 /admin/assignments

List all assignments.

=cut

sub assignments :Path('/admin/assignments') :Args(0) {
  my ($self, $c) = @_;

  my @assignments = $c->model('PRCDB::Assignment')->search({
  },{
    prefetch => ['user', {'repo' => 'user'}],
  })->all;

  @assignments = map {{
    id        => $_->assignment_id,
    month     => $_->month_sortable,

    cont_id   => $_->user_id,
    cont      => $_->user->github_login,

    maint_id  => $_->repo->user_id,
    maint     => $_->repo->user->github_login,

    repo_name => substr($_->repo->github_full_name,0,40),
    repo_url  => $_->repo->github_html_url,

    status_color  => $_->status_color,
    status_string => $_->status_string,
  }} @assignments;

  # Group per month
  my $assignments_per_month;
  foreach my $assignment (@assignments){
    $assignments_per_month->{$assignment->{month}} //= [];
    push @{$assignments_per_month->{$assignment->{month}}}, $assignment;
  }

  PRC::Event->log($c, 'VIEW_ADMIN_ASSIGNMENTS');
  $c->stash({
    assignments_per_month => $assignments_per_month,
    template   => 'static/html/admin/assignments.html',
    active_tab => 'assignments',
  });

}

=head2 /admin/assignment/<id>

List one assignment and send emails for it.

=cut

sub assignment :Path('/admin/assignment') :Args(1) {
  my ($self, $c, $id) = @_;

  my $assignment = $c->model('PRCDB::Assignment')->find($id);

  my $new_assignment_email_form = PRC::Form::NewAssignmentEmail->new;
  $c->stash({ new_assignment_email_form => $new_assignment_email_form });
  $new_assignment_email_form->process(params => $c->req->params);

  my $open_reminder_email_form = PRC::Form::OpenReminderEmail->new;
  $c->stash({ open_reminder_email_form => $open_reminder_email_form });
  $open_reminder_email_form->process(params => $c->req->params);

  my $timeout_email_form = PRC::Form::TimeoutEmail->new;
  $c->stash({ timeout_email_form => $timeout_email_form });
  $timeout_email_form->process(params => $c->req->params);

  if($c->req->params->{submit_new_assignment_email} && $new_assignment_email_form->validated){
    PRC::Email->send_new_assignment_email($assignment);
    PRC::Event->log($c, 'SUCCESS_NEW_ASSIGNMENT_EMAIL');
    $c->session({ alert_success => 'New Assignment email sent.' });
    $c->response->redirect('/admin/assignment/'.$id,303);
    $c->detach;
  }

  if($c->req->params->{submit_open_reminder_email} && $open_reminder_email_form->validated){
    PRC::Email->send_open_reminder_email($assignment);
    PRC::Event->log($c, 'SUCCESS_OPEN_REMINDER_EMAIL');
    $c->session({ alert_success => 'Open Reminder email sent.' });
    $c->response->redirect('/admin/assignment/'.$id,303);
    $c->detach;
  }

  if($c->req->params->{submit_timeout_email} && $timeout_email_form->validated){
    PRC::Email->send_timeout_email($assignment);
    PRC::Event->log($c, 'SUCCESS_TIMEOUT_EMAIL');
    $c->session({ alert_success => 'Timeout email sent.' });
    $c->response->redirect('/admin/assignment/'.$id,303);
    $c->detach;
  }

  PRC::Event->log($c, 'VIEW_ADMIN_ASSIGNMENT_ID');
  $c->stash({
    assignment => $assignment,
    template   => 'static/html/admin/assignment.html',
  });
}

sub _yymmdd {
  my ($datetime) = @_;
  return '' unless $datetime;
  return $datetime =~ s/^\d{2}(\d{2})-(\d{2})-(\d{2}).*/$1$2$3/r;
}

sub _get_open_assignment_month_sortable {
  my @assignments = @_;
  my $open_assignment = first {$_->status == ASSIGNMENT_OPEN} @assignments;
  return "" unless $open_assignment;
  return $open_assignment->month_sortable;
}

sub _get_assignee_counts {
  my ($user, @assignments) = @_;
  my @repos = $user->repos->all;
  my @repo_ids = map {$_->repo_id} @repos;

  my $assignees_total   = 0;
  my $assignees_open    = 0;
  my $assignees_skip    = 0;
  my $assignees_deleted = 0;
  my $assignees_timeout = 0;
  my $assignees_done    = 0;

  foreach my $assignment (@assignments){
    if ( any {$assignment->repo_id eq $_} @repo_ids ){
      $assignees_total++;
      if ($assignment->status eq ASSIGNMENT_OPEN){
        $assignees_open++;
      } elsif ($assignment->status eq ASSIGNMENT_SKIPPED){
        $assignees_skip++;
      } elsif ($assignment->status eq ASSIGNMENT_DELETED){
        $assignees_deleted++;
      } elsif ($assignment->status eq ASSIGNMENT_TIMEOUT){
        $assignees_timeout++;
      } elsif ($assignment->status eq ASSIGNMENT_DONE){
        $assignees_done++;
      }
    }
  }

  return {
    assignees_total   => $assignees_total || '',
    assignees_open    => $assignees_open  || '',
    assignees_skip    => $assignees_skip  || '',
    assignees_deleted => $assignees_deleted || '',
    assignees_timeout => $assignees_timeout || '',
    assignees_done    => $assignees_done  || '',
  };
}

sub _get_repo_counts {
  my ($user) = @_;
  my @repos = grep {!$_->gone_missing} $user->repos->all;

  my $per_repos_tot = grep {!$_->org_id} @repos;
  my $per_repos_opt = grep {!$_->org_id && $_->accepting_assignees} @repos;
  my $org_repos_tot = grep {$_->org_id} @repos;
  my $org_repos_opt = grep {$_->org_id && $_->accepting_assignees} @repos;
  my $all_repos_tot = $org_repos_tot + $per_repos_tot;
  my $all_repos_opt = $org_repos_opt + $per_repos_opt;

  return {
    personal_repos_total    => $per_repos_tot || '',
    personal_repos_opted_in => $per_repos_opt || '',
    org_repos_total         => $org_repos_tot || '',
    org_repos_opted_in      => $org_repos_opt || '',
    all_repos_total         => $all_repos_tot || '',
    all_repos_opted_in      => $all_repos_opt || '',
  };
}

=head2 /admin/email

Send email to users

=cut

sub email :Path('/admin/email') :Args(0) {
  my ($self, $c) = @_;

  my $new_feature_email_form = PRC::Form::Admin::NewFeatureEmail->new;
  $c->stash({ new_feature_email_form => $new_feature_email_form });
  $new_feature_email_form->process(params => $c->req->params);

  if($c->req->params->{submit_new_feature_email} && $new_feature_email_form->validated){
    my @user_ids = split(',', $new_feature_email_form->values->{user_ids});
    foreach my $user_id (@user_ids){
      my $user = $c->model('PRCDB::User')->find($user_id);
      use DDP; warn np $user;
      next unless $user;
      PRC::Email->send_new_feature_email($user);
      PRC::Event->log($c, 'SUCCESS_NEW_FEATURE_EMAIL');
    }
    $c->session({ alert_success => 'New Feature emails sent.' });
    $c->response->redirect('/admin/email', 303);
    $c->detach;
  }

  PRC::Event->log($c, 'VIEW_ADMIN_EMAIL');
  $c->stash({
    form     => $new_feature_email_form,
    template => 'static/html/admin/email.html',
  });
}

__PACKAGE__->meta->make_immutable;

1;
