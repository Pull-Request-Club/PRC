package PRC::Form::Settings::General;
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

has_field 'is_syncing_forked_repos' => (
  type  => 'Checkbox',
  label => 'Sync forked repos?',
  checkbox_value      => 1,
  input_without_param => 0,
);

has_field 'submit_general' => (
  type  => 'Submit',
  value => 'Save Settings',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
