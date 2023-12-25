package PRC::Form::TimeoutEmail;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::GitHub;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit_timeout_email' => (
  type  => 'Submit',
  value => 'Email timeout',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
