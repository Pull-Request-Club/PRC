package PRC::Form::OrgRepos;
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

has_field 'org_repo_select' => (
  type     => 'Select',
  label    => 'Please select organizational repositories
               that you want to assign to other people.',
  widget   => 'CheckboxGroup',
  multiple => 1,
);

sub options_org_repo_select {
  my ($self) = @_;
  my $user  = $self->user;
  my @repos = $user->available_org_repos;
  return [] unless scalar @repos;

  my @options = map {{
    value    => $_->github_id,
    label    => build_repo_option_label($_),
    selected => $_->accepting_assignees,
  }} sort {
    (lc $a->github_full_name) cmp (lc $b->github_full_name)
  } @repos;
  return \@options;
}

sub build_repo_option_label {
  my ($repo) = @_;
  my $name  = $repo->github_full_name;
  my $lang  = $repo->github_language;
  my $count = $repo->github_open_issues_count;

  my $label = $name . ' (';
  $label   .= "$lang, " if $lang;
  $label   .= ($count == 0) ? "No issues)"
            : ($count == 1) ? "1 issue)"
                            : "$count issues)";
  return $label;
}

has_field 'submit_org_repos' => (
  type  => 'Submit',
  value => 'Save Organizational Repositories',
  element_attr => { class => 'btn btn-success' },
);

__PACKAGE__->meta->make_immutable;
1;
