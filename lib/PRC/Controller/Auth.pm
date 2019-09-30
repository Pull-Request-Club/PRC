package PRC::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use DateTime;
use PRC::GitHub;
use PRC::Form::Reactivate;

=encoding utf8

=head1 NAME

PRC::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 login

This is where the "Log in with GitHub" link goes to. Immediately redirects.

=cut

sub login :Path('/login') :Args(0) {
  my ($self, $c) = @_;

  # TODO: add a "state" and keep it in session

  my $redirect_url = $c->user_exists ? '/' : PRC::GitHub->authenticate_url;
  $c->response->redirect($redirect_url,303);
  $c->detach;
}

=head2 login_error

A private action that sets an error message and detaches to '/'.

=cut

sub login_error :Private {
  my ($self, $c, $error) = @_;

  $error ||= 'Login was not successful, please try again.';
  $c->session->{alert_danger} = $error;
  $c->response->redirect('/',303);
  $c->detach;
}

=head2 callback

GitHub sends users here after authorization. We get a code.

=cut

sub callback :Path('/callback') :Args(0) {
  my ($self, $c) = @_;

  # TODO: rate limit this endpoint.

  if ($c->user_exists){
    $c->response->redirect('/my-assignment',303);
    $c->detach;
  }

  my $code         = $c->req->params->{code}               or $c->forward('login_error');
  my $access_token = PRC::GitHub->access_token($code)      or $c->forward('login_error');
  my $user_data    = PRC::GitHub->user_data($access_token) or $c->forward('login_error');
  my $github_email = PRC::GitHub->get_email($access_token) or $c->forward('login_error',
    ['We had trouble getting your primary verified email from GitHub. Please try again.']);

  # If existing user, update data. New user, add to DB.
  my $db_args = {
    last_login_time => DateTime->now->datetime,
    github_id       => $user_data->{id},
    github_login    => $user_data->{login},
    github_email    => $github_email,
    github_token    => $access_token,
    github_profile  => $user_data->{html_url},
  };
  my $rs   = $c->model('PRCDB::User');
  my $user = $rs->search({ github_id => $user_data->{id}})->first;
  if ($user){
    $user->update($db_args);
  } else {
    $user = $rs->create($db_args);
    # If that didn't work, kick out
    $c->forward('login_error') unless $user;
  }

  # LOGIN HAPPENS!
  $c->authenticate({ user_id => $user->id });
  $c->session->{alert_success} = 'You are now logged in!';
  $c->response->redirect('/my-assignment',303);
  $c->detach;
}

=head2 logout

Clear session, logout, send to /.

=cut

sub logout :Path('/logout') :Args(0) {
  my ($self, $c, $message) = @_;

  if (!$c->user_exists){
    $c->response->redirect('/',303);
    $c->detach;
  }

  my $has_seen_cookie_notice = $c->session->{has_seen_cookie_notice};

  $c->delete_session;
  $c->logout;

  if ($has_seen_cookie_notice){
    $c->session->{has_seen_cookie_notice} = 1;
  }

  $c->session->{alert_success} = $message || "You are now logged out.";

  $c->response->redirect('/hello',303);
  $c->detach;
}

=head2 reactivate

Page to redirect people who have deactivated their account and logged in.

=cut

sub reactivate :Path('/reactivate') :Args(0) {
  my ($self, $c) = @_;

  my $user = $c->user;
  if (!$user || $user->is_active){
    $c->response->redirect('/',303);
    $c->detach;
  }

  my $form = PRC::Form::Reactivate->new;
  $form->process(params => $c->req->params);
  if($form->validated){
    $user->activate;
    $c->session->{alert_success} = 'Your account is now activated! Welcome back!';
    $c->response->redirect('/my-assignment',303);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/reactivate.html',
    form     => $form,
    ($user->scheduled_delete_time
      ? ( scheduled_delete_time => $user->scheduled_delete_time->ymd )
      : ()
    ),
  });
}

__PACKAGE__->meta->make_immutable;

1;
