use utf8;
package PRC::Schema::Result::Legal;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Legal

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

=head1 TABLE: C<legal>

=cut

__PACKAGE__->table("legal");

=head1 ACCESSORS

=head2 legal_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 create_time

  data_type: 'datetime'
  is_nullable: 0

=head2 is_latest

  data_type: 'boolean'
  is_nullable: 0

=head2 version

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "legal_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "create_time",
  { data_type => "datetime", is_nullable => 0 },
  "is_latest",
  { data_type => "boolean", is_nullable => 0 },
  "version",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</legal_id>

=back

=cut

__PACKAGE__->set_primary_key("legal_id");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-10-27 16:30:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HuxLyThf1C2jDh0wcetlzg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
