package PRC::Form::Deactivate;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit' => (
  type  => 'Submit',
  value => 'Deactivate',
  element_attr => { class => 'btn btn-danger btn-lg' },
);

__PACKAGE__->meta->make_immutable;
1;
