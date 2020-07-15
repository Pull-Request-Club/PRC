use utf8;
package PRC::Schema::Result::Repo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::Repo

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

=head1 TABLE: C<repo>

=cut

__PACKAGE__->table("repo");

=head1 ACCESSORS

=head2 repo_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 org_id

  data_type: 'integer'
  default_value: null
  is_foreign_key: 1
  is_nullable: 1

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

=head2 accepting_assignees

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=head2 github_id

  data_type: 'integer'
  is_nullable: 0

=head2 github_name

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 github_full_name

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 github_language

  data_type: 'varchar'
  default_value: null
  is_nullable: 1
  size: 256

=head2 github_is_fork

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=head2 github_html_url

  data_type: 'varchar'
  is_nullable: 0
  size: 512

=head2 github_events_url

  data_type: 'varchar'
  is_nullable: 0
  size: 512

=head2 github_open_issues_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 github_stargazers_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 github_forks_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "repo_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "org_id",
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
  "update_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_update => 1,
  },
  "gone_missing",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "accepting_assignees",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "github_id",
  { data_type => "integer", is_nullable => 0 },
  "github_name",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "github_full_name",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "github_language",
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 256,
  },
  "github_is_fork",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "github_html_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_events_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_open_issues_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "github_stargazers_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "github_forks_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</repo_id>

=back

=cut

__PACKAGE__->set_primary_key("repo_id");

=head1 RELATIONS

=head2 assignments

Type: has_many

Related object: L<PRC::Schema::Result::Assignment>

=cut

__PACKAGE__->has_many(
  "assignments",
  "PRC::Schema::Result::Assignment",
  { "foreign.repo_id" => "self.repo_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 org

Type: belongs_to

Related object: L<PRC::Schema::Result::Org>

=cut

__PACKAGE__->belongs_to(
  "org",
  "PRC::Schema::Result::Org",
  { org_id => "org_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
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


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-07-15 17:29:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H4PbkdcrlAnkgrLVTX58EQ


__PACKAGE__->meta->make_immutable;
1;
