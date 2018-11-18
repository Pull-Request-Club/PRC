package PRC::Form::AcceptLegal;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit_accept_legal' => (
  type  => 'Submit',
  value => 'I have read and agree to terms of use, privacy policy and cookie policy.',
  element_attr => { class => 'btn btn-success btn-lg btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
