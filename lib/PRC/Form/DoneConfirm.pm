package PRC::Form::DoneConfirm;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit' => (
  type  => 'Submit',
  value => 'Yes, continue',
  element_attr => { class => 'btn btn-success' },
);

# TODO validate with GitHub.

__PACKAGE__->meta->make_immutable;
1;
