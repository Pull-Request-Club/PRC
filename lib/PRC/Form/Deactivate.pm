package PRC::Form::Deactivate;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit_deactivate' => (
  type  => 'Submit',
  value => 'Deactivate My Account',
  element_attr => { class => 'btn btn-danger' },
);

__PACKAGE__->meta->make_immutable;
1;
