package PRC::Form::DeleteAccount;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit_delete_account' => (
  type  => 'Submit',
  value => 'Delete My Account',
  element_attr => { class => 'btn btn-danger btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
