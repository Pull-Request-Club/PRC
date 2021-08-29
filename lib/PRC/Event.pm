package PRC::Event;

use namespace::autoclean;

use PRC::Model::PRCDB;

=encoding utf8

=head1 NAME

PRC::Event - A Quick Library for events

=head1 DESCRIPTION

This is a library to log events in DB.

=head1 METHODS

=head2 log

Takes in c (ok if there's no user within) and a message.

=cut

sub log {
  my ($self, $c, $event_string) = @_;

  my $rs      = $c->model('PRCDB::Event');
  my $user    = $c->user;
  my $user_id = $user ? $user->user_id : 0;
  $event_string ||= 'ERROR_EVENT_STRING_MISSING';

  $rs->create({
    user_id      => $user_id,
    event_string => $event_string,
  });
}

=head2 log_no_c

Takes in user (ok if it's not there) and a message.
Works without $c.

=cut

sub log_no_c {
  my ($self, $user, $event_string) = @_;

  my $schema  = PRC::Model::PRCDB->new;
  my $rs      = $schema->resultset('Event');
  my $user_id = $user ? $user->user_id : 0;
  $event_string ||= 'ERROR_EVENT_STRING_MISSING';

  $rs->create({
    user_id      => $user_id,
    event_string => $event_string,
  });
}

1;
