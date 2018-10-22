package PRC::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 METHODS

=head2 auto

=cut

sub auto :Private {
  my ($self, $c) = @_;

  $c->stash({
    alert_success => delete $c->session->{alert_success},
    alert_info    => delete $c->session->{alert_info},
    alert_warning => delete $c->session->{alert_warning},
    alert_danger  => delete $c->session->{alert_danger},
    # logged_in   => ($c->user_exists ? 1 : 0),
  });

}


=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
  my ($self, $c) = @_;
  # TODO: redirect to my assignment if logged in
  $c->stash({
    template => 'static/html/hello.html',
  });
}

=head2 about

/about

=cut

sub about :Local :Args(0) {
  my ($self, $c) = @_;
  $c->stash({
    template => 'static/html/about.html',
  });
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
  my ( $self, $c ) = @_;

  $c->response->body('Page not found');
  $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
