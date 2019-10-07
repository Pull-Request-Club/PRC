package PRC::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Constants;
use PRC::Form::Assignment;
use PRC::Form::DeactivateConfirm;
use PRC::Form::DeleteConfirm;
use PRC::Form::DoneConfirm;
use PRC::Form::Languages;
use PRC::Form::OrgRepos;
use PRC::Form::PersonalRepos;
use PRC::Form::ReloadOrgRepos;
use PRC::Form::ReloadPersonalRepos;
use PRC::Form::SkipConfirm;

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

=head2 add_announcement

A private action that adds announcement.
TODO: Make a table for site-wide announcements and read from DB.

=cut

sub add_announcement :Private {
  my ($self, $c) = @_;
  my $user = $c->user;
  return 1 unless $user;

  # Now you can select preferred languages (until mid November)
  if (!$user->has_any_active_user_langs
    && DateTime->now < DateTime->new({year=>2019,month=>11,day=>15})
  ){
    $c->stash->{alert_info} = "Now you can select your preferred languages! Click \"Settings\" above to get started.";
  }

}


=head2 settings

=cut

sub settings :Path('/settings') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated
  $c->forward('check_user_status',[{ skip_legal_check => 1 }]);
  my $user = $c->user;

  my $has_accepted_latest_terms = $user->has_accepted_latest_terms;

  # Go ahead with assignment setting and repo/org sync logic if agreed to TOS
  if($has_accepted_latest_terms){
    my $last_personal_repo_sync_time = $user->last_personal_repo_sync_time;
    my $last_org_repo_sync_time      = $user->last_org_repo_sync_time;
    my $has_any_av_personal_repos    = $user->has_any_available_personal_repos;
    my $has_any_av_org_repos         = $user->has_any_available_org_repos;

    if (!$last_personal_repo_sync_time){
      $c->stash({never_synced_personal_repos => 1, hide_personal_repos => 1});
    } elsif (!$has_any_av_personal_repos){
      $c->stash({hide_personal_repos => 1});
    }
    if (!$last_org_repo_sync_time){
      $c->stash({never_synced_org_repos => 1, hide_org_repos => 1});
    } elsif (!$has_any_av_org_repos){
      $c->stash({hide_org_repos =>1});
    }

    # If we are coming back from GitHub additional scope confirmation, reload org repos
    if (delete $c->session->{fetch_org_reauth_done}){
      $user->fetch_org_repos;
      $c->session({ alert_success => 'Your organizational repositories are loaded.' });
      # Reload
      $c->response->redirect('/settings',303);
      $c->detach;
    }

    # Reload Personal Repositories
    my $reload_personal_repos_form = PRC::Form::ReloadPersonalRepos->new;
    $c->stash({ reload_personal_repos_form => $reload_personal_repos_form });
    $reload_personal_repos_form->process(params => $c->req->params);
    if($c->req->params->{submit_reload_personal_repos} && $reload_personal_repos_form->validated){
      $user->fetch_personal_repos;
      $c->session({ alert_success => 'Your personal repositories are reloaded.' });
      # Reload
      $c->response->redirect('/settings',303);
      $c->detach;
    }

    # Personal Repositories
    my $personal_repos_form = PRC::Form::PersonalRepos->new(user => $user);
    $c->stash({ personal_repos_form => $personal_repos_form });
    $personal_repos_form->process(params => $c->req->params);
    if($c->req->params->{submit_personal_repos} && $personal_repos_form->validated){
      my $selected_repos = $personal_repos_form->values->{personal_repo_select};
      foreach my $repo ($user->available_personal_repos){
        my $github_id   = $repo->github_id;
        my $is_selected = (any {$_ eq $github_id} @$selected_repos) ? 1 : 0;
        $repo->update({ accepting_assignees => $is_selected });
      }
      $c->stash->{alert_success} = 'Your selected personal repositories are updated.';
    }

    # Reload Organizational Repositories
    my $reload_org_repos_form = PRC::Form::ReloadOrgRepos->new;
    $c->stash({ reload_org_repos_form => $reload_org_repos_form });
    $reload_org_repos_form->process(params => $c->req->params);
    if($c->req->params->{submit_reload_org_repos} && $reload_org_repos_form->validated){
      # Check if we have "read:org" scope for this user. If not, ask for that.
      my $can_get_orgs = PRC::GitHub->can_get_orgs($user->github_token);
      if (!$can_get_orgs){
        $c->session->{fetch_org_reauth} = 1;
        $c->response->redirect(PRC::GitHub->org_authenticate_url,303);
        $c->detach;
      }
      # Continue if we have the scope
      $user->fetch_org_repos;
      $c->session({ alert_success => 'Your organizational repositories are reloaded.' });
      # Reload
      $c->response->redirect('/settings',303);
      $c->detach;
    }

    # Organizational Repositories
    my $org_repos_form = PRC::Form::OrgRepos->new(user => $user);
    $c->stash({ org_repos_form => $org_repos_form });
    $org_repos_form->process(params => $c->req->params);
    if($c->req->params->{submit_org_repos} && $org_repos_form->validated){
      my $selected_repos = $org_repos_form->values->{org_repo_select};
      foreach my $repo ($user->available_org_repos){
        my $github_id   = $repo->github_id;
        my $is_selected = (any {$_ eq $github_id} @$selected_repos) ? 1 : 0;
        $repo->update({ accepting_assignees => $is_selected });
      }
      $c->stash->{alert_success} = 'Your selected organizational repositories are updated.';
    }

    # Assignment Settings
    my $assignment_form = PRC::Form::Assignment->new;
    $c->stash({ assignment_form => $assignment_form });
    $assignment_form->process(
      params   => $c->req->params,
      defaults => {
        is_receiving_assignments => $user->is_receiving_assignments,
      }
    );
    if($c->req->params->{submit_assignment} && $assignment_form->validated){
      my $new_value = $assignment_form->values->{is_receiving_assignments};
      $user->update({ is_receiving_assignments => $new_value });
      if ($new_value){
        $c->stash->{alert_success} = 'Yes! Welcome to the club!';
      } else {
        $c->stash->{alert_success} = 'You have opted out from getting assignments. We hope to see you again soon!';
      }
    }

    # Preferred Languages
    my $languages_form = PRC::Form::Languages->new(user => $user);
    $c->stash({ languages_form => $languages_form });
    $languages_form->process(params => $c->req->params);
    if($c->req->params->{submit_languages} && $languages_form->validated){
      my $selected_langs = $languages_form->values->{lang_select};
      $user->update_langs($selected_langs);
      $c->stash->{alert_success} = 'Your preferred languages are updated.';
    }

  } # end TOS check

  $c->stash({
    template   => 'static/html/settings.html',
    active_tab => 'settings',
    has_accepted_latest_terms => $has_accepted_latest_terms,
  });
}

=head2 my_assignment

=cut

sub my_assignment :Path('/my-assignment') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal
  $c->forward('check_user_status');
  $c->forward('add_announcement');
  my $user = $c->user;

  $c->stash({
    assignment => $user->open_assignment,
    opted_in   => $user->is_receiving_assignments,
    template   => 'static/html/my-assignment.html',
    active_tab => 'my-assignment',
  });
}

=head2 my_repos

Redirect to /settings, not used any more.

=cut

sub my_repos :Path('/my-repos') :Args(0) {
  my ($self, $c) = @_;
  $c->response->redirect('/settings',303);
  $c->detach;
}

=head2 history

=cut

sub history :Path('/history') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated + agreed to legal
  $c->forward('check_user_status');
  $c->forward('add_announcement');
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
    $c->session->{alert_success} = 'You have done a great job! Now is time to brag about it: Post a tweet or write a blog. Feel free to tag us along @PullRequestClub. See you next month!';
    $c->response->redirect('/history',303);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/done-confirm.html',
    form     => $form,
  });
}

=head2 deactivate_confirm

=cut

sub deactivate_confirm :Path('/deactivate-confirm') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated
  $c->forward('check_user_status',[{ skip_legal_check => 1 }]);
  my $user = $c->user;
  my $form = PRC::Form::DeactivateConfirm->new;
  $form->process(params => $c->req->params);
  if($form->validated){
    $user->deactivate;
    my $message = 'Your account is now deactivated. We hope to see you again soon!';
    $c->forward('/auth/logout',[$message]);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/deactivate-confirm.html',
    form     => $form,
  });
}

=head2 delete_confirm

=cut

sub delete_confirm :Path('/delete-confirm') :Args(0) {
  my ($self, $c) = @_;

  # must be logged in + activated
  $c->forward('check_user_status',[{ skip_legal_check => 1 }]);
  my $user = $c->user;
  my $form = PRC::Form::DeleteConfirm->new;
  $form->process(params => $c->req->params);
  if($form->validated){
    $user->schedule_deletion;
    my $message = 'Your account is now deactivated and will be deleted in 30 days. We hope to see you again!';
    $c->forward('/auth/logout',[$message]);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/deactivate-confirm.html',
    form     => $form,
  });
}
__PACKAGE__->meta->make_immutable;

1;
