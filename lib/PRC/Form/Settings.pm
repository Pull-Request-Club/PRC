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
  type    => 'Select',
  label   => 'Please select an option for your assignments.',
  options => [
    {
      label => 'QUIT: I don\'t want to receive any assignments.',
      value =>  USER_ASSIGNMENT_QUIT,
    },
    {
      label => 'SKIP: I want to stop receiving assignments for one month.',
      value => USER_ASSIGNMENT_SKIP,
    },
    {
      label => 'ACTIVE: I want to receive assignments every month.',
      value => USER_ASSIGNMENT_ACTIVE,
    },
  ],
);

has_field 'assignee_level' => (
  type    => 'Select',
  label   => 'Please select an option for your repositories.',
  options => [
    {
      label => 'QUIT: I don\'t want my repositories to be assigned.',
      value => USER_ASSIGNEE_QUIT,
    },
    {
      label => 'ACTIVE: I want my selected repositories to be assigned.' ,
      value => USER_ASSIGNEE_ACTIVE,
    },
  ],
);


has_field 'submit_settings' => (
  type  => 'Submit',
  value => 'Save my settings',
  element_attr => { class => 'btn btn-success btn-lg btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
