use utf8;
package PRC::Schema::Result::Repo;

=head1 NAME

PRC::Schema::Result::Repo

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

# TODO ADD uniq constraint to github_id

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");
__PACKAGE__->table("repo");
__PACKAGE__->add_columns(
  "repo_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
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
  "github_html_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_pulls_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_events_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_issues_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_issue_events_url",
  { data_type => "varchar", is_nullable => 0, size => 512 },
  "github_open_issues_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "github_stargazers_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

__PACKAGE__->set_primary_key("repo_id");

__PACKAGE__->belongs_to(
  "user",
  "PRC::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

__PACKAGE__->meta->make_immutable;
1;
