package PRC::Form::Reactivate;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit' => (
  type  => 'Submit',
  value => 'Reactivate',
  element_attr => { class => 'btn btn-success btn-lg btn-block' },
  wrapper_attr => { class => 'form-group' },
);

__PACKAGE__->meta->make_immutable;
1;
