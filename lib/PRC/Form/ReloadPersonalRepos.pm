package PRC::Form::ReloadPersonalRepos;
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

has_field 'submit_reload_personal_repos' => (
  type  => 'Submit',
  value => 'Reload Personal Repositories',
  element_attr => { class => 'btn btn-primary btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
