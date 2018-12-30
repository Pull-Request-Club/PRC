use utf8;
package PRC::Schema::Result::Assignment;

=head1 NAME

PRC::Schema::Result::Assignment

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

use PRC::Constants;

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");
__PACKAGE__->table("assignment");
__PACKAGE__->add_columns(
  "assignment_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "repo_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "create_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_create => 1,
  },
  "update_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_update => 1,
  },
  "month",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "status",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

__PACKAGE__->set_primary_key("assignment_id");

__PACKAGE__->belongs_to(
  "repo",
  "PRC::Schema::Result::Repo",
  { repo_id => "repo_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

__PACKAGE__->belongs_to(
  "user",
  "PRC::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head1 METHODS

=head2 status_string

Returns text representation for status integer.

=cut

sub status_string {
  my ($assignment) = @_;
  my $status = $assignment->status;
  if ($status == ASSIGNMENT_OPEN){
    return "Open";
  } elsif ($status == ASSIGNMENT_SKIPPED){
    return "Skipped";
  } elsif ($status == ASSIGNMENT_DONE){
    return "Done";
  } else {
    return "Unknown";
  }
}

=head2 status_color

Returns bootstrap class that represents color for assignment.
Open    = Blue  = Primary
Skipped = Grey  = Secondary
Done    = Green = Success

=cut

sub status_color {
  my ($assignment) = @_;
  my $status = $assignment->status;
  if ($status == ASSIGNMENT_OPEN){
    return "primary";
  } elsif ($status == ASSIGNMENT_SKIPPED){
    return "secondary";
  } elsif ($status == ASSIGNMENT_DONE){
    return "success";
  } else {
    return "info" ;
  }
}

=head2 month_pretty

Returns pretty string for month row like "January 2019".

=cut

sub month_pretty {
  my ($assignment) = @_;
  my $month  = $assignment->month;
  my $pretty = $month->month_name . ' ' . $month->year;
  return $pretty;
}

=head2 mark_as_skipped

Updates assignment status as "SKIPPED".

=cut

sub mark_as_skipped {
  my ($assignment) = @_;
  $assignment->update({
    status => ASSIGNMENT_SKIPPED,
  });
}

=head2 mark_as_done

Updates assignment status as "DONE".

=cut

sub mark_as_done {
  my ($assignment) = @_;
  $assignment->update({
    status => ASSIGNMENT_DONE,
  });
}

__PACKAGE__->meta->make_immutable;
1;
