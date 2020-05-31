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
  label    => 'Please check repositories that you want assigned
               to contributors.<br>
               Then click "Save Organizational Repositories" button
               at the bottom of the page.<br>
               If you want to refresh the list, click "Reload
               Organizational Repositories" button.',
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
    selected => $_->accepting_assignees,
    name     => $_->github_full_name,
    url      => $_->github_html_url,
    lang     => $_->github_language,
    issues   => $_->github_open_issues_count,
    stars    => $_->github_stargazers_count,
  }} sort {
    (lc $a->github_full_name) cmp (lc $b->github_full_name)
  } @repos;
  return \@options;
}

has_field 'submit_org_repos' => (
  type  => 'Submit',
  value => 'Save Organizational Repositories',
  element_attr => { class => 'btn btn-success btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
