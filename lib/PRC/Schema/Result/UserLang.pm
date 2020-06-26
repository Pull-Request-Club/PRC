use utf8;
package PRC::Schema::Result::UserLang;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::UserLang

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

=head1 TABLE: C<user_lang>

=cut

__PACKAGE__->table("user_lang");

=head1 ACCESSORS

=head2 user_lang_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 lang_id

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

=cut

__PACKAGE__->add_columns(
  "user_lang_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "lang_id",
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
);

=head1 PRIMARY KEY

=over 4

=item * L</user_lang_id>

=back

=cut

__PACKAGE__->set_primary_key("user_lang_id");

=head1 RELATIONS

=head2 lang

Type: belongs_to

Related object: L<PRC::Schema::Result::Lang>

=cut

__PACKAGE__->belongs_to(
  "lang",
  "PRC::Schema::Result::Lang",
  { lang_id => "lang_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-10-05 08:47:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qg/YDtT3f5g2sfm5VxOfdQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
