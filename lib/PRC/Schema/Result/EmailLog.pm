use utf8;
package PRC::Schema::Result::EmailLog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::EmailLog

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

=head1 TABLE: C<email_log>

=cut

__PACKAGE__->table("email_log");

=head1 ACCESSORS

=head2 email_log_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 email_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 assignment_id

  data_type: 'integer'
  default_value: null
  is_foreign_key: 1
  is_nullable: 1

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "email_log_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "email_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "assignment_id",
  {
    data_type      => "integer",
    default_value  => \"null",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "create_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_create => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</email_log_id>

=back

=cut

__PACKAGE__->set_primary_key("email_log_id");

=head1 RELATIONS

=head2 assignment

Type: belongs_to

Related object: L<PRC::Schema::Result::Assignment>

=cut

__PACKAGE__->belongs_to(
  "assignment",
  "PRC::Schema::Result::Assignment",
  { assignment_id => "assignment_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 email

Type: belongs_to

Related object: L<PRC::Schema::Result::Email>

=cut

__PACKAGE__->belongs_to(
  "email",
  "PRC::Schema::Result::Email",
  { email_id => "email_id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c7cZSRBxRkbUQGrGL3kT+w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
