package PRC::Form::UnsubConfirm;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::GitHub;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit_unsub_confirm' => (
  type  => 'Submit',
  value => 'Yes, unsubscribe',
  element_attr => { class => 'btn btn-danger' },
);

__PACKAGE__->meta->make_immutable;
1;
