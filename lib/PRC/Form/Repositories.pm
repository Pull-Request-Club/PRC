package PRC::Form::Repositories;
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

has_field 'repo_select' => (
  type     => 'Select',
  label    => 'Please select repositories that you want to
               assign to other people.',
  widget   => 'CheckboxGroup',
  multiple => 1,
);

sub options_repo_select {
  my ($self) = @_;
  my $user  = $self->user;
  my @repos = $user->available_repos;
  return [] unless scalar @repos;

  my @options = map {{
    value    => $_->github_id,
    label    => build_repo_option_label($_),
    selected => $_->accepting_assignees,
  }} sort {
    $b->github_open_issues_count <=> $a->github_open_issues_count
      or
    $b->github_stargazers_count <=> $a->github_stargazers_count
  } @repos;
  return \@options;
}

sub build_repo_option_label {
  my ($repo) = @_;
  my $name  = $repo->github_full_name;
  my $lang  = $repo->github_language;
  my $count = $repo->github_open_issues_count;

  # TODO Add call to action to create new issues
  # TODO Make these clickable to GitHub
  # TODO make it into a table

  my $label = $name . ' (';
  $label   .= "$lang, " if $lang;
  $label   .= ($count == 0) ? "No issues)"
            : ($count == 1) ? "1 issue)"
                            : "$count issues)";
  return $label;
}

has_field 'submit_repositories' => (
  type  => 'Submit',
  value => 'Save my repositories',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
