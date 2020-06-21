use utf8;
package PRC::Schema::Result::Email;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Email

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

=head1 TABLE: C<email>

=cut

__PACKAGE__->table("email");

=head1 ACCESSORS

=head2 email_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 email_name

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 email_description

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 update_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "email_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "email_name",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "email_description",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "create_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "update_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</email_id>

=back

=cut

__PACKAGE__->set_primary_key("email_id");

=head1 RELATIONS

=head2 user_email_opt_ins

Type: has_many

Related object: L<PRC::Schema::Result::UserEmailOptIn>

=cut

__PACKAGE__->has_many(
  "user_email_opt_ins",
  "PRC::Schema::Result::UserEmailOptIn",
  { "foreign.email_id" => "self.email_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-06-22 00:08:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7fbpcX7woZ0Qt11Ye1CCrg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
