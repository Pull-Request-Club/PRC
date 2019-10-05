use utf8;
package PRC::Schema::Result::Org;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Org

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

=head1 TABLE: C<org>

=cut

__PACKAGE__->table("org");

=head1 ACCESSORS

=head2 org_id

  data_type: 'integer'
  is_auto_increment: 1
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

=head2 gone_missing

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=head2 github_id

  data_type: 'integer'
  is_nullable: 0

=head2 github_login

  data_type: 'varchar'
  is_nullable: 0
  size: 128

=head2 github_profile

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=cut

__PACKAGE__->add_columns(
  "org_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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
  "gone_missing",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "github_id",
  { data_type => "integer", is_nullable => 0 },
  "github_login",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "github_profile",
  { data_type => "varchar", is_nullable => 0, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</org_id>

=back

=cut

__PACKAGE__->set_primary_key("org_id");

=head1 RELATIONS

=head2 repos

Type: has_many

Related object: L<PRC::Schema::Result::Repo>

=cut

__PACKAGE__->has_many(
  "repos",
  "PRC::Schema::Result::Repo",
  { "foreign.org_id" => "self.org_id" },
  { cascade_copy => 0, cascade_delete => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2019-10-05 09:05:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VT9uKqlNaEsYacYH9h/HEw


__PACKAGE__->meta->make_immutable;
1;
