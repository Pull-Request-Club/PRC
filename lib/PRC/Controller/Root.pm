package PRC::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use PRC::Constants 'LATEST_LEGAL_DATE';
use PRC::Form::AcceptLegal;

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

  my $user = $c->user;

  unless (my $has_seen_cookie_notice = $c->session->{has_seen_cookie_notice}){
    $c->stash->{show_cookie_notice}       = 1;
    $c->session->{has_seen_cookie_notice} = 1;
  }

  $c->stash({
    alert_success => delete $c->session->{alert_success},
    alert_info    => delete $c->session->{alert_info},
    alert_warning => delete $c->session->{alert_warning},
    alert_danger  => delete $c->session->{alert_danger},
    $user ? ( logged_in => 1, github_login => $user->github_login ) : (),
  });

}


=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
  my ($self, $c) = @_;

  if($c->user_exists){
    $c->response->redirect('/my-assignment',303);
    $c->detach;
  }

  $c->stash({
    template => 'static/html/hello.html',
  });
}

=head2 help

/help

Show some information about PRC + help users.

=cut

sub help :Local :Args(0) {
  my ($self, $c) = @_;

  $c->stash({
    template => 'static/html/help.html',
  });
}

=head2 legal

/legal

Display Terms of Use, Privacy Policy, GDPR Notice.
Users will be redirected to here from my-assignment & my-repos
if they have not agreed to terms yet. These will get a form,
through which they can accept terms.

=cut

sub legal :Local :Args(0) {
  my ($self, $c) = @_;

  my $user = $c->user;

  if ($user && !$user->has_accepted_latest_terms){
    my $form = PRC::Form::AcceptLegal->new;
    $form->process(params => $c->req->params);
    $c->stash({ form => $form });

    if($form->validated){
      $user->accept_latest_terms;
      $c->response->redirect('/my-assignment',303);
      $c->detach;
    }
  }
  elsif ($user){
    $c->stash({ accepted_date => $user->tos_agree_time->ymd });
  }

  $c->stash({
    template       => 'static/html/legal.html',
    effective_date => LATEST_LEGAL_DATE->ymd,
  });
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
  my ( $self, $c ) = @_;

  $c->response->body('Page not found.');
  $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
