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

=head2 last_personal_repo_sync_time

  data_type: 'datetime'
  default_value: null
  is_nullable: 1

=head2 last_org_repo_sync_time

  data_type: 'datetime'
  default_value: null
  is_nullable: 1

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

=head2 is_receiving_assignments

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
  "last_personal_repo_sync_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "last_org_repo_sync_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "tos_agree_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "tos_agreed_version",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "scheduled_delete_time",
  { data_type => "datetime", default_value => \"null", is_nullable => 1 },
  "is_deactivated",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "is_receiving_assignments",
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

=head1 RELATIONS

=head2 assignments

Type: has_many

Related object: L<PRC::Schema::Result::Assignment>

=cut

__PACKAGE__->has_many(
  "assignments",
  "PRC::Schema::Result::Assignment",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orgs

Type: has_many

Related object: L<PRC::Schema::Result::Org>

=cut

__PACKAGE__->has_many(
  "orgs",
  "PRC::Schema::Result::Org",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 repos

Type: has_many

Related object: L<PRC::Schema::Result::Repo>

=cut

__PACKAGE__->has_many(
  "repos",
  "PRC::Schema::Result::Repo",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_email_opt_ins

Type: has_many

Related object: L<PRC::Schema::Result::UserEmailOptIn>

=cut

__PACKAGE__->has_many(
  "user_email_opt_ins",
  "PRC::Schema::Result::UserEmailOptIn",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_langs

Type: has_many

Related object: L<PRC::Schema::Result::UserLang>

=cut

__PACKAGE__->has_many(
  "user_langs",
  "PRC::Schema::Result::UserLang",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-06-22 00:08:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wtome4HBjVyAtu8zcfFkgw

use DateTime;
use PRC::Constants;
use PRC::GitHub;
use List::Util qw/any first/;

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

=head2 has_accepted_latest_terms

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

=head2 can_receive_assignments

This reflects whether this user can receive an assignment next month.
It will be false if user chose not to receive an assignment.
It will also be false if user currently has an open assignment.

=cut

sub can_receive_assignments {
  my ($user) = @_;
  return $user->has_accepted_latest_terms
    && $user->is_receiving_assignments
    && !$user->has_open_assignment;
}

=head2 open_assignment

Return open (current) assignment object assigned to user, if any.

=cut

sub open_assignment {
  my ($user) = @_;
  return $user->assignments->search({
    status => ASSIGNMENT_OPEN,
  })->first;
}

=head2 has_open_assignment

Returns if user has an OPEN assignment assigned to them.

=cut

sub has_open_assignment {
  my ($user) = @_;
  return $user->open_assignment ? 1 : 0;
}

=head2 assignments_taken

Returns all assignments assigned to this user.
Sorted by descending date.
Joined with repos and repo-owner users.

=cut

sub assignments_taken {
  my ($user) = @_;
  return $user->assignments->search({},{
    # Join "repo" on assignment, then "user" on "repo".
    # So that we get repo details of assignment, and also
    # user details of (owner of the) repo.
    prefetch => {repo  => 'user' },
    order_by => {-desc => 'month'},
  })->all;
}

=head2 assignments_given

Returns all assignments of this user's repositories.
These are assignments assigned to other users.
Sorted by descending date.
Joined with repos and assignment-owner users.

=cut

sub assignments_given {
  my ($user) = @_;
  return $user->result_source->schema->resultset('Assignment')->search({
    'repo.user_id' => $user->id,
  },{
    # Join "repo" on assignment to get repo details.
    # Join "user" on assignment as well, so that we get details of
    # user who got the repository as their assignment.
    prefetch => ['user', 'repo'],
    order_by => {-desc => 'month'},
  })->all;
}

=head2 received_assignment_count

Count of total assignments received. Returned as a hashref.

=cut

sub received_assignment_count {
  my ($user) = @_;
  my @assignments = $user->assignments->all;

  my $counts = {
    total     => int(@assignments)                                                 || 0,
    done      => (scalar(grep {$_->status == ASSIGNMENT_DONE}    @assignments))    || 0,
    skipped   => (scalar(grep {$_->status == ASSIGNMENT_SKIPPED} @assignments))    || 0,
    open      => (scalar(grep {$_->status == ASSIGNMENT_OPEN}    @assignments))    || 0,
  };

  my $score = 5 * $counts->{total} + 20 * $counts->{done} - 1 * $counts->{skipped};
  $counts->{score} = $score;
  return $counts;
}

=head2 fetch_personal_repos

Fetch PERSONAL repositories from GitHub. Add/update repo table.
Returns undef if something went wrong.

=cut

sub fetch_personal_repos {
  my ($user) = @_;

  # Collect existing and fetched repos
  my @existing_repos = $user->personal_repos;
  my $fetched_repos  = PRC::GitHub->get_repos($user->github_token,0); # org = 0
  return undef unless defined $fetched_repos;

  # Loop through all fetched repositories
  foreach my $fetched_repo (@$fetched_repos){

    my $matching_existing_repo =
      first {$_->github_id == $fetched_repo->{github_id}} @existing_repos;
    if ($matching_existing_repo){
      $matching_existing_repo->update($fetched_repo);
    } else {
      $user->create_related('repos',$fetched_repo);
    }

  } # end loop fetched repos

  # Mark repositories that didn't come back as "gone missing"
  foreach my $existing_repo (@existing_repos){
    my $existing_repo_is_fetched =
      any {
        $_->{github_id} == $existing_repo->github_id
      } @$fetched_repos;
    if (!$existing_repo_is_fetched){
      $existing_repo->update({ gone_missing => 1 });
    }
  }

  $user->update({ last_personal_repo_sync_time => DateTime->now->datetime });

  return 1;
}

=head2 fetch_org_repos

Fetch ORG repositories from GitHub. Add/update org/repo tables.
Returns undef if something went wrong.

=cut

sub fetch_org_repos {
  my ($user) = @_;

  # Update orgs first
  $user->fetch_orgs;

  # Collect available orgs
  my @available_orgs = $user->available_orgs;
  my $av_org_map;
  foreach my $av_org (@available_orgs){
    $av_org_map->{$av_org->github_id} = $av_org->org_id;
  }

  # Collect existing and fetched repos
  my @existing_repos = $user->org_repos;
  my $fetched_repos  = PRC::GitHub->get_repos($user->github_token,1); # org = 1
  return undef unless defined $fetched_repos;

  # Loop through all fetched repositories
  foreach my $fetched_repo (@$fetched_repos){

    my $fetched_org_github_id = delete $fetched_repo->{org_github_id};
    next unless $fetched_org_github_id;

    # If it belongs to an available organization, add our own org_id
    if (my $org_id = $av_org_map->{$fetched_org_github_id}){
      $fetched_repo->{org_id} = $org_id;
    }
    # Otherwise, add a flag that says ignore, and don't update db
    else {
      $fetched_repo->{ignore} = 1;
      next;
    }

    # Now to update database.
    # If it's not there yet, add it and link it to this user
    # If it's added by this user, update
    # If it's added by someone else, mark it as "ignore".
    my $repo = $user->result_source->schema->resultset('Repo')->search({
      github_id => $fetched_repo->{github_id}
    })->first;

    if (!$repo){
      $user->create_related('repos',$fetched_repo);
    } elsif($repo->user_id == $user->user_id){
      $repo->update($fetched_repo);
    } else {
      $fetched_repo->{ignore} = 1;
    }

  } # end loop fetched repos

  # Mark repositories that didn't come back as "gone missing"
  foreach my $existing_repo (@existing_repos){
    my $existing_repo_is_fetched =
      any {
        $_->{github_id} == $existing_repo->github_id
        && !$_->{ignore}
      } @$fetched_repos;
    if (!$existing_repo_is_fetched){
      $existing_repo->update({ gone_missing => 1 });
    }
  }

  $user->update({ last_org_repo_sync_time => DateTime->now->datetime });

  return 1;
}

=head2 personal_repos

Returns an array of personal repositories.

=cut

sub personal_repos {
  my ($user) = @_;
  return $user->repos->search({
    org_id => undef,
  })->all;
}

=head2 available_personal_repos

Returns an array of personal repositories that are not gone missing.

=cut

sub available_personal_repos {
  my ($user) = @_;
  return $user->repos->search({
    gone_missing => 0,
    org_id => undef,
  })->all;
}

=head2 has_any_available_personal_repos

Returns a boolean representing whether user has any available personal repos.

=cut

sub has_any_available_personal_repos {
  my ($user) = @_;
  return $user->repos->search({
    gone_missing => 0,
    org_id => undef,
  })->count ? 1 : 0;
}

=head2 org_repos

Returns an array of org repositories.

=cut

sub org_repos {
  my ($user) = @_;
  return $user->repos->search({
    org_id => { not => undef },
  })->all;
}

=head2 available_org_repos

Returns an array of org repositories that are not gone missing.

=cut

sub available_org_repos {
  my ($user) = @_;
  return $user->repos->search({
    gone_missing => 0,
    org_id => { not => undef },
  })->all;
}

=head2 has_any_available_org_repos

Returns a boolean representing whether user has any available org repos.

=cut

sub has_any_available_org_repos {
  my ($user) = @_;
  return $user->repos->search({
    gone_missing => 0,
    org_id => { not => undef },
  })->count ? 1 : 0;
}

=head2 fetch_orgs

Fetch organizations from GitHub. Add/update org table.
Returns undef if something went wrong.
Assumes user has accepted read:org scope.

=cut

sub fetch_orgs {
  my ($user) = @_;

  my @existing_orgs = $user->orgs;
  my $fetched_orgs  = PRC::GitHub->get_orgs($user->github_token);
  return undef unless defined $fetched_orgs;

  # Loop through each fetched organization
  foreach my $fetched_org (@$fetched_orgs){
    # If it's not there yet, add it and link it to this user
    # If it's added by this user, update
    # If it's added by someone else, don't make any changes
    my $org = $user->result_source->schema->resultset('Org')->search({
      github_id => $fetched_org->{github_id}
    })->first;
    if (!$org){
      $user->create_related('orgs',$fetched_org);
    } elsif($org->user_id == $user->user_id){
      $org->update($fetched_org);
    }
  }

  # Loop through this user's organizations to mark missing ones
  foreach my $existing_org (@existing_orgs){
    my $existing_org_is_fetched =
      any {$_->{github_id} == $existing_org->github_id} @$fetched_orgs;
    if (!$existing_org_is_fetched){
      $existing_org->update({ gone_missing => 1 });
    }
  }

  return 1;
}

=head2 available_orgs

Returns an array of organizations that are not gone missing.

=cut

sub available_orgs {
  my ($user) = @_;
  return $user->orgs->search({
    gone_missing => 0
  })->all;
}

=head2 has_any_available_orgs

Returns a boolean representing whether user has any available orgs.

=cut

sub has_any_available_orgs {
  my ($user) = @_;
  return $user->orgs->search({
    gone_missing => 0
  })->count ? 1 : 0;
}

=head2 active_user_langs

Same as $user->user_langs, except this doesn't
return rows if a lang.gone_missing = 1.

=cut

sub active_user_langs {
  my ($user) = @_;
  return $user->user_langs->search({
    'lang.gone_missing' => 0,
  },{
    join => 'lang',
  })->all;
};

=head2 active_user_langs_string

Same as $user->active_user_langs, except this
returns a string joined by , for printing.

=cut

sub active_user_langs_string {
  my ($user) = @_;
  my @langs = $user->user_langs->all;
  my @lang_strings = ();
  foreach my $lang (@langs){
    push @lang_strings, $lang->lang->lang_name;
  }
  return join(', ',@lang_strings);
}

=head2 has_any_active_user_langs

Returns a boolean representing whether user has any selected langs.

=cut

sub has_any_active_user_langs {
  my ($user) = @_;
  return $user->user_langs->search({
    'lang.gone_missing' => 0,
  },{
    join => 'lang',
  })->count ? 1 : 0;
};

=head2 selected_lang_ids

Same as $user->active_user_langs, except this
returns a hash of ids as keys and 1 as value.
Example: { 9 => 1, 10 => 1}

=cut

sub selected_lang_ids {
  my ($user) = @_;
  my @selected_langs = $user->user_langs->search({
    'lang.gone_missing' => 0,
  },{
    select => 'lang_id',
    join   => 'lang',
  })->all;
  my %lang_ids = map {$_->lang_id => 1} @selected_langs;
  return %lang_ids;
}

=head2 update_langs($langs)

Update preferred languages of user.

=cut

sub update_langs {
  my ($user,$new) = @_;
  my @old = $user->active_user_langs;
  my %old = map {$_->lang_id => 1} @old;
  my %new = map {$_ => 1} @$new;

  # The ones in old but not in new will be deleted
  foreach my $old_row (@old){
    if(!$new{$old_row->lang_id}){
      $old_row->delete;
    }
  }

  # The ones in new but not in old will be inserted
  foreach my $new_id (@$new){
    if(!$old{$new_id}){
      $user->create_related('user_langs',{lang_id => $new_id});
    }
  }

  return 1;

}

=head2 selected_email_ids

Returns a hash of user's opted in emails.
Example: { 9 => 1, 10 => 1}

=cut

sub selected_email_ids {
  my ($user) = @_;
  my @selected_emails = $user->user_email_opt_ins->search({
  },{
    select => 'email_id',
    join   => 'email',
  })->all;
  my %email_ids = map {$_->email_id => 1} @selected_emails;

  return %email_ids;
}

=head2 update_emails($emails)

Update opted in emails of user.

=cut

sub update_emails {
  my ($user,$new) = @_;
  my @old = $user->user_email_opt_ins;
  my %old = map {$_->email_id => 1} @old;
  my %new = map {$_ => 1} @$new;

  # The ones in old but not in new will be deleted
  foreach my $old_row (@old){
    if(!$new{$old_row->email_id}){
      $old_row->delete;
    }
  }

  # The ones in new but not in old will be inserted
  foreach my $new_id (@$new){
    if(!$old{$new_id}){
      $user->create_related('user_email_opt_ins',{email_id => $new_id});
    }
  }

  return 1;
}

=head2 subscribe_to_all_emails

Subscribe to all emails

=cut

sub subscribe_to_all_emails {
  my ($user) = @_;

  my @all_emails = $user->result_source->schema->resultset('Email')->get_column('email_id')->all;
  $user->update_emails(\@all_emails);
}

=head2 add_welcome_to_prc_assignment

Add first "welcome to prc" assignment
TODO: Send a special new-assignment email with "welcome" copy.

=cut

sub add_welcome_to_prc_assignment {
  my ($user) = @_;

  my $welcome_to_prc_repo = $user->result_source->schema->resultset('Repo')
    ->search({ github_id => 268291406 })->first;
  return undef unless $welcome_to_prc_repo;

  my $assignment = $user->create_related('assignments',{
    repo_id => $welcome_to_prc_repo->repo_id,
    month   => DateTime->now->ymd,
  });

  return $assignment;
}

__PACKAGE__->meta->make_immutable;
1;
