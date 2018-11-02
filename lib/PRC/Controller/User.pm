package PRC::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Form::Deactivate;
use PRC::Form::DeleteAccount;

=encoding utf8

=head1 NAME

PRC::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 check_user_status

A private action that can make sure user
- is logged in
- has an active account (not marked for deactivation/deletion)
- has agreed to latest TOU/PP/GDPR.


Otherwise, send them to correct places.

=cut

sub check_user_status :Private {
  my ($self, $c, $args) = @_;

  $args  //= {};
  my $user = $c->user;
  my $skip_legal_check = $args->{skip_legal_check};

  unless ($user){
    $c->session->{alert_danger} = 'You need to login first.';
    $c->response->redirect($c->uri_for('/'),303);
    $c->detach;
  }

  # check if user has deactivated their account
  if($user->is_deactivated || $user->scheduled_delete_time){
    $c->response->redirect($c->uri_for('/reactivate'),303);
    $c->detach;
  }

  # Check if user has agreed to legal (tos/pp/gdpr)
  if(!$skip_legal_check && !$user->has_accepted_latest_terms){
    $c->response->redirect($c->uri_for('/legal'),303);
    $c->detach;
  }

}


=head2 my_profile

=cut

sub my_profile :Path('/my-profile') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated
  $c->forward('check_user_status',[{ skip_legal_check => 1 }]);
  my $user = $c->user;

  my $deactivate_form     = PRC::Form::Deactivate->new;
  my $delete_account_form = PRC::Form::DeleteAccount->new;

  $deactivate_form->process(params => $c->req->params);
  if($c->req->params->{submit_deactivate} && $deactivate_form->validated){
    my $message = 'Your account is now deactivated.';
    $user->deactivate;
    $c->forward('/auth/logout',[$message]);
  }

  $delete_account_form->process(params => $c->req->params);
  if($c->req->params->{submit_delete_account} && $delete_account_form->validated){
    my $message = 'Your account is now deactivated and scheduled for a deletion in 30 days.';
    $user->schedule_deletion;
    $c->forward('/auth/logout',[$message]);
  }

  $c->stash({
    template   => 'static/html/my-profile.html',
    active_tab => 'my-profile',
    deactivate_form     => $deactivate_form,
    delete_account_form => $delete_account_form,
  });
}


=head2 my_assignment

=cut

sub my_assignment :Path('/my-assignment') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal
  $c->forward('check_user_status');

  $c->stash({
    template   => 'static/html/my-assignment.html',
    active_tab => 'my-assignment',
  });
}


=head2 my_repos

=cut

sub my_repos :Path('/my-repos') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal
  $c->forward('check_user_status');

  $c->stash({
    template   => 'static/html/my-repos.html',
    active_tab => 'my-repos',
  });
}

__PACKAGE__->meta->make_immutable;

1;
