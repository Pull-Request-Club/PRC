package PRC::Form::Settings::Emails;
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

has_field 'email_select' => (
  type     => 'Select',
  label    => 'Please select emails you would like to receive.',
  widget   => 'CheckboxGroup',
  multiple => 1,
);

sub options_email_select {
  my ($self) = @_;
  my $user  = $self->user;

  my @all_emails = $user->result_source->schema->resultset('Email')->search({});
  my %selected_emails = $user->selected_email_ids;

  my @options = map {{
    value    => $_->email_id,
    label    => _label($_),
    selected => $selected_emails{$_->email_id} ? 1 : 0,
  }} @all_emails;
  return \@options;
}

sub _label {
  my ($email) = @_;
  my $name = $email->email_name;
  my $desc = $email->email_description;
  my $print_name = join(' ',map {ucfirst} split('-',$name));
  return $print_name . ': '. $desc;
}

has_field 'submit_emails' => (
  type  => 'Submit',
  value => 'Save Opted In Emails',
  element_attr => { class => 'btn btn-success btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
