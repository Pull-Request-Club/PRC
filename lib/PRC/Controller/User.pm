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


=head2 my_profile

=cut

sub my_profile :Path('/my-profile') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->body('/my-profile');
}

=head2 my_assignment

=cut

sub my_assignment :Path('/my-assignment') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->body('/my-assignment');
}

=head2 my_profile

=cut

sub my_repos :Path('/my-repos') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->body('/my-repos');
}

__PACKAGE__->meta->make_immutable;

1;
