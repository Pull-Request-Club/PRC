package PRC::Form::DoneConfirm;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;
use PRC::GitHub;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has 'assignment' => (
  is       => 'ro',
  isa      => 'PRC::Model::PRCDB::Assignment',
  required => 1,
);

has_field '_token' => (
  type  => 'RequestToken',
);

has_field 'submit' => (
  type  => 'Submit',
  value => 'Yes, continue',
  element_attr => { class => 'btn btn-success' },
);

sub validate {
  my ($form)   = @_;
  my $message  = "I can't confirm the PR on GitHub. If you think this is an error, please contact us.";
  my $repo     = $form->assignment->repo;
  my $assignee = $form->assignment->user;

  # Confirm PR here
  unless (PRC::GitHub->confirm_pr($repo, $assignee, $form->assignment)){
    $form->add_form_error($message);
  }
}

__PACKAGE__->meta->make_immutable;
1;
