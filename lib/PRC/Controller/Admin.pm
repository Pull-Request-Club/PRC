package PRC::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Constants;
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
    $c->stash({ hide_navbar => 1, hide_footer => 1 });
    return 1;
  }

  # Default to 404
  $c->response->body('Page not found.');
  $c->response->status(404);
  $c->detach;
}


=head2 /admin

Redirect to /admin/users

=cut

sub admin :Path('/admin') :Args(0) {
  my ($self, $c) = @_;
  $c->response->redirect('/admin/users',303);
  $c->detach;
}

=head2 /admin/users

List all users.

=cut

sub users :Path('/admin/users') :Args(0) {
  my ($self, $c) = @_;

  my @users = $c->model('PRCDB::User')->search({},{
    prefetch => ['repos','assignments'],
  })->all;
  my @assignments = $c->model('PRCDB::Assignment')->all;

  @users = map {{
    user_id               => $_->user_id,
    github_login          => $_->github_login,
    last_login_time       => $_->last_login_time =~ s/T/ /r,
    accepted_latest_tos   => $_->has_accepted_latest_terms ? "Yes" : "",
    deactivation_status   => $_->scheduled_delete_time
                             ? "Delete by ".$_->scheduled_delete_time =~ s/T.*//r
                             : $_->is_deactivated ? "Deactivated" : "",
    assignment_status     => $_->is_receiving_assignments ? "Yes" : "",
    open_assignment_month => _get_open_assignment_month_sortable($_->assignments),
    assignments_total     => $_->assignments->count,
    assignments_done      => scalar(grep {$_->status == ASSIGNMENT_DONE} $_->assignments),
    repos_total           => scalar($_->repos),
    repos_opted_in        => scalar(grep {$_->accepting_assignees == 1} $_->repos),
    %{_get_assignees_total_and_done($_,@assignments)},
  }} @users;

  $c->stash({
    users    => \@users,
    template => 'static/html/admin-users.html',
  });

}

sub _get_open_assignment_month_sortable {
  my @assignments = @_;
  my $open_assignment = first {$_->status == ASSIGNMENT_OPEN} @assignments;
  return "" unless $open_assignment;
  return $open_assignment->month_sortable;
}

sub _get_assignees_total_and_done {
  my ($user, @assignments) = @_;
  my @repos = $user->repos->all;
  my @repo_ids = map {$_->repo_id} @repos;

  my $assignees_total = 0;
  my $assignees_done  = 0;
  foreach my $assignment (@assignments){
    if ( any {$assignment->repo_id eq $_} @repo_ids ){
      $assignees_total++;
      if ($assignment->status eq ASSIGNMENT_DONE){
        $assignees_done++;
      }
    }
  }

  return {
    assignees_total => $assignees_total,
    assignees_done  => $assignees_done,
  };
}

__PACKAGE__->meta->make_immutable;

1;
