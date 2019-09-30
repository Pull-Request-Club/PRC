package PRC::Form::DeleteConfirm;
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
  value => 'Yes, schedule a deletion for my account and log me out',
  element_attr => { class => 'btn btn-danger' },
);

__PACKAGE__->meta->make_immutable;
1;
