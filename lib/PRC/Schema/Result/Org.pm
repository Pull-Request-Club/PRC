use utf8;
package PRC::Schema::Result::Org;

=head1 NAME

PRC::Schema::Result::Org

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");
__PACKAGE__->table("org");
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

__PACKAGE__->set_primary_key("org_id");

__PACKAGE__->belongs_to(
  "user",
  "PRC::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

__PACKAGE__->meta->make_immutable;
1;
