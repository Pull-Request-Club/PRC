package PRC::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=encoding utf8

=head1 NAME

PRC::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 login

=cut

sub login :Path('/login') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->body('/login');
}


=head2 callback

=cut

sub callback :Path('/callback') :Args(0) {
  my ( $self, $c ) = @_;
  my $code = $c->req->params->{code} // '';
  $c->response->body('/callback with code=' . $code);
}

=head2 logout

=cut

sub logout :Path('/logout') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->body('/logout');
}

__PACKAGE__->meta->make_immutable;

1;
