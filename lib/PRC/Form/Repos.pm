package PRC::Form::Repos;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::Constants;

has 'user' => (
  is       => 'ro',
  isa      => 'Catalyst::Authentication::Store::DBIx::Class::User',
  required => 1
);

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'repo_select' => (
  type     => 'Select',
  widget   => 'CheckboxGroup',
  multiple => 1,
  element_attr => { class => 'form-control form-control-lg' },
  wrapper_attr => { class => 'form-group' },
);

sub options_repo_select {
  my ($self) = @_;
  my $user  = $self->user;
  my @repos = $user->available_repos;
  return [] unless scalar @repos;

  # TODO Add call to action to create new issues
  # TODO Make these clickable to GitHub
  # TODO one repo per line (css)
  my @options = map {{
    value    => $_->github_id,
    label    => $_->github_name . ' ('. $_->github_language . ', ' .
                $_->github_open_issues_count . ' issues)',
    selected => $_->accepting_assignees,
  }} sort {
    $b->github_open_issues_count <=> $a->github_open_issues_count
      or
    $b->github_stargazers_count <=> $a->github_stargazers_count
  } @repos;
  return \@options;
}

has_field 'submit_repos' => (
  type  => 'Submit',
  value => 'Save my repository settings',
  element_attr => { class => 'btn btn-success btn-lg btn-block' },
  wrapper_attr => { class => 'form-group' },
);

__PACKAGE__->meta->make_immutable;
1;
