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
use PRC::Constants;

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");
__PACKAGE__->table("user");
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
  "assignment_level",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "assignee_level",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
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

__PACKAGE__->set_primary_key("user_id");

__PACKAGE__->has_many(
  "repos",
  "PRC::Schema::Result::Repo",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 has_accepted_to_latest_terms

Returns 1 if user has accepted latest terms.

=cut

sub has_accepted_latest_terms {
  my ($user) = @_;
  return 0 unless $user->tos_agree_time;
  return ( $user->tos_agree_time > LATEST_LEGAL_DATE ) ? 1 : 0;
}

=head2 accept_latest_terms

Accepts latest terms.

=cut

sub accept_latest_terms {
  my ($user) = @_;
  $user->update({
    tos_agree_time     => DateTime->now->datetime,
    tos_agreed_version => LATEST_LEGAL_DATE,
  });
}

=head2 is_receiving_assignees

Returns true if assignee level is active.

=cut

sub is_receiving_assignees {
  my ($user) = @_;
  return ($user->assignee_level == USER_ASSIGNEE_ACTIVE) ? 1 : 0;
}

__PACKAGE__->meta->make_immutable;
1;
