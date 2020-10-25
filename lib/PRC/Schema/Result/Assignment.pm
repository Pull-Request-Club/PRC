use utf8;
package PRC::Schema::Result::Assignment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Assignment

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<assignment>

=cut

__PACKAGE__->table("assignment");

=head1 ACCESSORS

=head2 assignment_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 repo_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 update_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 month

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 status

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

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

=head1 PRIMARY KEY

=over 4

=item * L</assignment_id>

=back

=cut

__PACKAGE__->set_primary_key("assignment_id");

=head1 RELATIONS

=head2 email_logs

Type: has_many

Related object: L<PRC::Schema::Result::EmailLog>

=cut

__PACKAGE__->has_many(
  "email_logs",
  "PRC::Schema::Result::EmailLog",
  { "foreign.assignment_id" => "self.assignment_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 repo

Type: belongs_to

Related object: L<PRC::Schema::Result::Repo>

=cut

__PACKAGE__->belongs_to(
  "repo",
  "PRC::Schema::Result::Repo",
  { repo_id => "repo_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<PRC::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PRC::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-06-30 23:23:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F1OarE7Is58XJBIUr3l/ng

use PRC::Constants;

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
  } elsif ($status == ASSIGNMENT_DELETED){
    return "Deleted";
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
  } elsif ($status == ASSIGNMENT_DELETED){
    return "warning";
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

=head2 month_sortable

Returns string for month row as "1908" (YYMM).

=cut

sub month_sortable {
  my ($assignment) = @_;
  my $datetime     = $assignment->month;
  return '' unless $datetime;
  return $datetime =~ s/^\d{2}(\d{2})-(\d{2}).*/$1$2/r;
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
