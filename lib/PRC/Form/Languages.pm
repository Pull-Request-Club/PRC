package PRC::Form::Languages;
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

has_field 'lang_select' => (
  type     => 'Select',
  label    => 'Please select your preferred languages. We cannot guarantee
               you will get an assignment in your preferred language.',
  widget   => 'CheckboxGroup',
  multiple => 1,
);

sub options_lang_select {
  my ($self) = @_;
  my $user  = $self->user;

  my @all_langs = $user->result_source->schema->resultset('Lang')->search({
    gone_missing => 0,
  });
  my %selected_langs = $user->selected_lang_ids;

  my @options = map {{
    value    => $_->lang_id,
    label    => $_->lang_name,
    selected => $selected_langs{$_->lang_id} ? 1 : 0,
  }} sort {
    (lc $a->lang_name) cmp (lc $b->lang_name)
  } @all_langs;
  return \@options;
}

has_field 'submit_languages' => (
  type  => 'Submit',
  value => 'Save Preferred Languages',
  element_attr => { class => 'btn btn-success btn-block' },
);

__PACKAGE__->meta->make_immutable;
1;
