package PRC::Form::Admin::NewFeatureEmail;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::GitHub;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
  type  => 'RequestToken',
);


has_field 'user_ids' => (
  type => 'Text',
);

has_field 'submit_new_feature_email' => (
  type  => 'Submit',
  value => 'Email new-feature',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
