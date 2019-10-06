package PRC::Form::Assignment;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use List::Util qw/none/;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'is_receiving_assignments' => (
  type  => 'Checkbox',
  label => 'Get assignments?',
  checkbox_value      => 1,
  input_without_param => 0,
);

has_field 'submit_assignment' => (
  type  => 'Submit',
  value => 'Save Assignment Settings',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
