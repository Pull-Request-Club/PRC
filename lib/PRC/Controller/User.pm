package PRC::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Form::Repos;
use PRC::Form::Settings;
use PRC::Form::Deactivate;
use PRC::Form::DeleteAccount;
use PRC::Form::SkipConfirm;
use PRC::Form::DoneConfirm;

use List::Util qw/any/;

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
- has an open assignment (if requested)


Otherwise, send them to correct places.

=cut

sub check_user_status :Private {
  my ($self, $c, $args) = @_;

  $args  //= {};
  my $user = $c->user;
  my $skip_legal_check = $args->{skip_legal_check};
  my $check_open_assignment = $args->{check_open_assignment};

  unless ($user){
    $c->session->{alert_danger} = 'You need to login first.';
    $c->response->redirect('/',303);
    $c->detach;
  }

  # check if user has deactivated their account
  if($user->is_deactivated || $user->scheduled_delete_time){
    $c->response->redirect('/reactivate',303);
    $c->detach;
  }

  # Check if user has agreed to legal (tos/pp/gdpr)
  if(!$skip_legal_check && !$user->has_accepted_latest_terms){
    $c->response->redirect('/legal',303);
    $c->detach;
  }

  # Check if user has an open assignment
  if($check_open_assignment && !$user->has_open_assignment){
    $c->response->redirect('/my-assignment',303);
    $c->detach;
  }

}


=head2 settings

=cut

sub settings :Path('/settings') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated
  $c->forward('check_user_status',[{ skip_legal_check => 1 }]);
  my $user = $c->user;

  my $settings_form       = PRC::Form::Settings->new;
  my $deactivate_form     = PRC::Form::Deactivate->new;
  my $delete_account_form = PRC::Form::DeleteAccount->new;

  $deactivate_form->process(params => $c->req->params);
  if($c->req->params->{submit_deactivate} && $deactivate_form->validated){
    my $message = 'Your account is now deactivated.';
    $user->deactivate;
    $c->forward('/auth/logout',[$message]);
    $c->detach;
  }

  $delete_account_form->process(params => $c->req->params);
  if($c->req->params->{submit_delete_account} && $delete_account_form->validated){
    my $message = 'Your account is now deactivated and scheduled for a deletion in 30 days.';
    $user->schedule_deletion;
    $c->forward('/auth/logout',[$message]);
    $c->detach;
  }

  $settings_form->process(
    params   => $c->req->params,
    defaults => {
      assignment_level => $user->assignment_level,
      assignee_level   => $user->assignee_level,
    }
  );
  if($c->req->params->{submit_settings} && $settings_form->validated){
    # Note that values are validated by HTML::FormHandler
    my $values = $settings_form->values;
    $user->update({
      assignment_level => $values->{assignment_level},
      assignee_level   => $values->{assignee_level},
    });
    $c->stash->{alert_success} = 'Your settings are saved!';
  }

  $c->stash({
    template   => 'static/html/settings.html',
    active_tab => 'settings',
    settings_form       => $settings_form,
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
  my $user = $c->user;

  $c->stash({
    assignment => $user->open_assignment,
    user_can_receive_assignments   => $user->can_receive_assignments,
    user_has_open_assignment       => $user->has_open_assignment,
    user_has_assignment_level_skip => $user->has_assignment_level_skip,
    user_has_assignment_level_quit => $user->has_assignment_level_quit,
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
  my $user = $c->user;

  if($user->can_receive_assignees){

    if($c->req->params->{reload_repos}){
      $user->update({last_repos_sync => undef});
      $c->stash->{alert_success} = 'Your repositories were reloaded!';
    }
    # Fetch repos
    # TODO: throw away if errors
    $user->fetch_repos;

    my $form  = PRC::Form::Repos->new(user => $user);
    $form->process(params => $c->req->params);

    # Form is submitted and valid
    if($form->params->{submit_repos} && $form->validated){
      my $selected_repos = $form->values->{repo_select};

      foreach my $repo ($user->available_repos){
        my $github_id   = $repo->github_id;
        my $is_selected = (any {$_ eq $github_id} @$selected_repos) ? 1 : 0;
        $repo->update({ accepting_assignees => $is_selected });
      }
      $c->stash->{alert_success} = 'Your repository settings are updated!';

    }

    $c->stash->{form} = $form;

  }

  # User not receiving assignees anyway
  else {
    $c->stash->{not_receiving_assignees} = 1;
  }

  $c->stash({
    template   => 'static/html/my-repos.html',
    active_tab => 'my-repos',
  });
}

=head2 history

=cut

sub history :Path('/history') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal
  $c->forward('check_user_status');
  my $user = $c->user;

  my @taken = $user->assignments_taken;
  my @given = $user->assignments_given;

  $c->stash({
    taken       => \@taken,
    given       => \@given,
    template    => 'static/html/history.html',
    active_tab  => 'history',
  });
}

=head2 skip_confirm

=cut

sub skip_confirm :Path('/skip-confirm') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal + has open assignment
  $c->forward('check_user_status',[{ check_open_assignment => 1 }]);
  my $user = $c->user;

  my $form = PRC::Form::SkipConfirm->new;
  $form->process(params => $c->req->params);
  if($form->validated){
    $user->open_assignment->mark_as_skipped;
    $c->session->{alert_success} = 'You have skipped your assignment.';
    $c->response->redirect('/history',303);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/skip-confirm.html',
    form     => $form,
  });
}

=head2 done_confirm

=cut

sub done_confirm :Path('/done-confirm') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal + has open assignment
  $c->forward('check_user_status',[{ check_open_assignment => 1 }]);
  my $user = $c->user;
  my $form = PRC::Form::DoneConfirm->new(assignment => $user->open_assignment);
  $form->process(params => $c->req->params);
  if($form->validated){
    $user->open_assignment->mark_as_done;
    $c->session->{alert_success} = 'You have completed your assignment!';
    $c->response->redirect('/history',303);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/done-confirm.html',
    form     => $form,
  });
}
__PACKAGE__->meta->make_immutable;

1;
