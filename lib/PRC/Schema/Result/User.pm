use utf8;
package PRC::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PRC::Schema::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 create_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 update_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 last_login_time

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 0

=head2 tos_agree_time

  data_type: 'datetime'
  default_value: null
  is_nullable: 1

=head2 tos_agreed_version

  data_type: 'datetime'
  default_value: null
  is_nullable: 1

=head2 scheduled_delete_time

  data_type: 'datetime'
  default_value: null
  is_nullable: 1

=head2 is_deactivated

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

=head2 github_email

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 github_profile

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 github_token

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
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
  "last_login_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "tos_agree_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "tos_agreed_version",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "scheduled_delete_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "is_deactivated",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "github_id",
  { data_type => "integer", is_nullable => 0 },
  "github_login",
  { data_type => "varchar", is_nullable => 0, size => 128 },
  "github_email",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "github_profile",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "github_token",
  { data_type => "varchar", is_nullable => 0, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-10-27 20:55:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IH8hucIoA9i1qAoCqyA43g

=head1 METHODS

=head2 is_active

Returns true if user is not deactivated and did not schedule a deletion.

=cut

sub is_active {
  my ($user) = @_;
  return !$user->is_deactivated && !$user->scheduled_delete_time;
}

=head2 activate

Clears is_deactivated and scheduled_delete_time.

=cut

sub activate {
  my ($user) = @_;
  $user->update({
    is_deactivated        => 0,
    scheduled_delete_time => undef,
  });
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
