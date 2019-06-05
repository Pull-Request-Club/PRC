package PRC::Form::Settings;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::Constants;
use List::Util qw/none/;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'assignment_level' => (
  type  => 'Checkbox',
  label => 'Give me assignments!',
  checkbox_value      => USER_ASSIGNMENT_ACTIVE,
  input_without_param => USER_ASSIGNMENT_QUIT,
);

has_field 'assignee_level' => (
  type  => 'Checkbox',
  label => 'Assign my repositories to other people!',
  checkbox_value      => USER_ASSIGNEE_ACTIVE,
  input_without_param => USER_ASSIGNEE_QUIT,
);


has_field 'submit_settings' => (
  type  => 'Submit',
  value => 'Save my settings',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
