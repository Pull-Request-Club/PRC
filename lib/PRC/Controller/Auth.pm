package PRC::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::GitHub;

=encoding utf8

=head1 NAME

PRC::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 login

See https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/
for GitHub's documentation on Authorizing OAuth Apps.

=cut

sub login :Path('/login') :Args(0) {
  my ($self, $c) = @_;

  #TODO: redirect only if not logged in.
  $c->response->redirect(PRC::GitHub->authenticate_url,303);
  $c->detach;
}

=head2 login_error

A private action that sets an error message and detaches to '/'.

=cut

sub login_error :Private {
  my ($self, $c) = @_;

  my $error = 'Login was not successful, please try again. If the issue persists please contact us.';
  $c->session->{alert_danger} = $error;
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;
}


=head2 callback

=cut

sub callback :Path('/callback') :Args(0) {
  my ($self, $c) = @_;

  my $code         = $c->req->params->{code}               or $c->forward('login_error');
  my $access_token = PRC::GitHub->access_token($code)      or $c->forward('login_error');
  my $user_data    = PRC::GitHub->user_data($access_token) or $c->forward('login_error');
  my $github_email = ($user_data->{email} // PRC::GitHub->primary_email($access_token))
    or $c->forward('login_error');

  # TODO: create or update user, then authenticate
  # github_id      => $user_data->{id}
  # github_login   => $user_data->{login}
  # github_email   => $user_data->{email} OR the second GET
  # github_token   => $token
  # github_profile => $user_data->{html_url}

  # TODO: Part 3: Get repositories of this user too
  # https://api.github.com/user/repos

  $c->session->{alert_info} = 'Done!';
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;
}

=head2 logout

=cut

sub logout :Path('/logout') :Args(0) {
  my ($self, $c) = @_;
  $c->delete_session;
  $c->logout;
  $c->response->redirect($c->uri_for('/'),303);
  $c->detach;
}

__PACKAGE__->meta->make_immutable;

1;
