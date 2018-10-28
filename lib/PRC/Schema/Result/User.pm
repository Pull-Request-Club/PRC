use utf8;
package PRC::Schema::Result::User;

=head1 NAME

PRC::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

use DateTime;

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
  default_value: null
  is_nullable: 1
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
    set_on_create => 1,
  },
  "update_time",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_update => 1,
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
  {
    data_type => "varchar",
    default_value => \"null",
    is_nullable => 1,
    size => 256,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");


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

=head2 deactivate

Sets is_deactivated to 1.

=cut

sub deactivate {
  my ($user) = @_;
  $user->update({
    is_deactivated => 1,
    github_token   => undef,
  });
}

=head2 schedule_deletion

Sets is_deactivated to 1 & schedules a deletion for 30 days.

=cut

sub schedule_deletion {
  my ($user) = @_;
  $user->update({
    is_deactivated        => 1,
    github_token          => undef,
    scheduled_delete_time => DateTime->now->add(days=>30)->datetime,
  });
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
