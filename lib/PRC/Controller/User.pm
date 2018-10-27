package PRC::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=encoding utf8

=head1 NAME

PRC::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 auto

=cut

sub auto :Private {
  # TODO: If not logged in, kick out.
  # If logged in but deactivated, ask.
  # If logged in but not accepted legal, ask.
  # Else, all good!
  1;
}

=head2 my_profile

=cut

sub my_profile :Path('/my-profile') :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash({
    template   => 'static/html/my-profile.html',
    active_tab => 'my-profile',
  });
}

=head2 my_assignment

=cut

sub my_assignment :Path('/my-assignment') :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash({
    template   => 'static/html/my-assignment.html',
    active_tab => 'my-assignment',
  });
}

=head2 my_profile

=cut

sub my_repos :Path('/my-repos') :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash({
    template   => 'static/html/my-repos.html',
    active_tab => 'my-repos',
  });
}

__PACKAGE__->meta->make_immutable;

1;
