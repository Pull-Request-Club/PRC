use utf8;
package PRC::Schema::Result::Lang;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Lang

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

=head1 TABLE: C<lang>

=cut

__PACKAGE__->table("lang");

=head1 ACCESSORS

=head2 lang_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 lang_name

  data_type: 'integer'
  is_nullable: 0

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 update_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 gone_missing

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "lang_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lang_name",
  { data_type => "integer", is_nullable => 0 },
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
  "gone_missing",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</lang_id>

=back

=cut

__PACKAGE__->set_primary_key("lang_id");

=head1 RELATIONS

=head2 user_langs

Type: has_many

Related object: L<PRC::Schema::Result::UserLang>

=cut

__PACKAGE__->has_many(
  "user_langs",
  "PRC::Schema::Result::UserLang",
  { "foreign.lang_id" => "self.lang_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-10-05 08:47:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8ilKj5ugGpsmeJ92qRi8jw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
