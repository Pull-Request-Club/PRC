package PRC::Email;
use namespace::autoclean;

use Email::SendGrid::V3;

=encoding utf8

=head1 NAME

PRC::Email - A Quick Library for sending emails

=head1 DESCRIPTION

This is a library to send emails through SendGrid Web API.

=head1 METHODS

=head2 send_new_assignment_email

Takes in assignment. Sends new assignment email.
Does no checks for TOS and opt-in (yet).

=cut

sub send_new_assignment_email {
  my ($self, $assignment) = @_;
  my $user = $assignment->user;
  my $email_id = 1;

  my $to = $user->github_email;
  my $subject = 'Your ' . $assignment->month_pretty . ' Assignment';
  my $unsub_link = PRC::Crypt->create_unsubscribe_link($user->user_id, $email_id);
  my $body= 'Hi!<br><br>
             You have a new assignment at Pull Request Club.<br><br>
             Please login at <a href="https://pullrequest.club">pullrequest.club</a> to see its details.<br><br>
             Kivanc @ Pull Request Club<br>
             Kadikoy, Istanbul, Turkey 34720<br><br>
             <a href="'.$unsub_link.'">Click to unsubscribe</a> from New Assignment emails.';

  my $sendgrid_api_key = PRC::Secrets->read('SG_API_KEY');
  return undef unless $sendgrid_api_key;

  Email::SendGrid::V3->new(api_key => $sendgrid_api_key)
    ->from('"Pull Request Club" <noreply@pullrequest.club>')
    ->reply_to('kyzn@cpan.org')
    ->subject($subject)
    ->add_content('text/html', $body)
    ->add_envelope( to => [ $to ] )
    ->send;

  $self->log_email($user,$email_id,$assignment->assignment_id);
}

=head2 send_open_reminder_email

Takes in assignment. Sends open reminder email.
Does no checks for TOS and opt-in (yet).

=cut

sub send_open_reminder_email {
  my ($self, $assignment) = @_;
  my $user = $assignment->user;
  my $email_id = 3;

  my $to = $user->github_email;
  my $subject = 'Reminder: Your ' . $assignment->month_pretty . ' Assignment';
  my $unsub_link = PRC::Crypt->create_unsubscribe_link($user->user_id, $email_id);
  my $body= 'Hi!<br><br>
             You seem to have an open assignment at Pull Request Club.<br>
             In order to receive new assignments you should finish or skip your current assignment.<br><br>
             Please login at <a href="https://pullrequest.club">pullrequest.club</a> to see details.<br><br>
             Kivanc @ Pull Request Club<br>
             Kadikoy, Istanbul, Turkey 34720<br><br>
             <a href="'.$unsub_link.'">Click to unsubscribe</a> from Open Reminder emails.';

  my $sendgrid_api_key = PRC::Secrets->read('SG_API_KEY');
  return undef unless $sendgrid_api_key;

  Email::SendGrid::V3->new(api_key => $sendgrid_api_key)
    ->from('"Pull Request Club" <noreply@pullrequest.club>')
    ->reply_to('kyzn@cpan.org')
    ->subject($subject)
    ->add_content('text/html', $body)
    ->add_envelope( to => [ $to ] )
    ->send;

  $self->log_email($user,$email_id,$assignment->assignment_id);
}

=head2 log_email

Add entry into email_log table.
Takes in user, email_id and an optional assignment_id.

=cut

sub log_email {
  my ($self, $user, $email_id, $assignment_id) = @_;
  return $user->create_related('email_logs',{ email_id => $email_id, assignment_id => $assignment_id });
}

1;
