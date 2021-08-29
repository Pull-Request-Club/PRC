package PRC::Controller::Email;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use PRC::Constants;
use PRC::Crypt;
use PRC::Event;
use PRC::Form::UnsubConfirm;

=encoding utf8

=head1 NAME

PRC::Controller::Email - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 unsub

=cut

sub unsub :Path('/unsub') :Args(2) {
  my ($self, $c, $ciphertext, $hmac) = @_;

  PRC::Event->log($c, 'VIEW_UNSUB');
  $c->stash({
    hide_navbar => 1,
    hide_footer => 1,
    template    => 'static/html/unsub-confirm.html',
  });

  unless ($ciphertext && $hmac){
    PRC::Event->log($c, 'ERROR_UNSUB_MISSING_ARG');
    $c->stash({ msg => "I can't confirm your unsubscribe link." });
    $c->detach;
  }

  my $data = PRC::Crypt->_decrypt_data({ciphertext => $ciphertext, hmac => $hmac});
  unless ($data){
    PRC::Event->log($c, 'ERROR_UNSUB_BAD_ARG');
    $c->stash({ msg => "I can't confirm your unsubscribe link." });
    $c->detach;
  }

  my $email_row  = $c->model('PRCDB::Email')->find($data->{email_id});
  my $email_name = $email_row->email_name;
  my $email_print_name = join(' ',map {ucfirst} split('-',$email_name));
  $c->stash({ email_print_name => $email_print_name });

  my $current_time = time();
  unless ($current_time < $data->{expire_time}){
    PRC::Event->log($c, 'ERROR_UNSUB_EXPIRED');
    $c->stash({ msg => "I can't confirm your unsubscribe link." });
    $c->detach;
  }

  my $unsub_confirm_form = PRC::Form::UnsubConfirm->new;
  $c->stash({ unsub_confirm_form => $unsub_confirm_form });
  $unsub_confirm_form->process(params => $c->req->params);

  if($c->req->params->{submit_unsub_confirm} && $unsub_confirm_form->validated){

    my $row = $c->model('PRCDB::UserEmailOptIn')->search({
      user_id  => $data->{user_id},
      email_id => $data->{email_id},
    })->first;

    if ($row){
      $row->delete;
      PRC::Event->log($c, 'SUCCESS_UNSUB');
    }

    $c->stash({ msg => "You are now unsubscribed from $email_print_name emails." });
    $c->detach;
  }

}

__PACKAGE__->meta->make_immutable;

1;
