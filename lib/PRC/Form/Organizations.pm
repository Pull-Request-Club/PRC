package PRC::Form::Organizations;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::Constants;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has 'user' => (
  is       => 'ro',
  isa      => 'Catalyst::Authentication::Store::DBIx::Class::User',
  required => 1,
);

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'org_select' => (
  type     => 'Select',
  label    => 'Please select organizations whose repositories
               you want to load for assignments. If your organization is
               already claimed by another user, we won\'t show it here.',
  widget   => 'CheckboxGroup',
  multiple => 1,
);

sub options_org_select {
  my ($self) = @_;
  my $user  = $self->user;
  my @orgs  = $user->available_orgs;
  return [] unless scalar @orgs;

  my @options = map {{
    value    => $_->github_id,
    label    => $_->github_login,
    selected => $_->is_fetching_repos,
  }} @orgs;
  return \@options;
}

has_field 'submit_organizations' => (
  type  => 'Submit',
  value => 'Save my organizations',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
