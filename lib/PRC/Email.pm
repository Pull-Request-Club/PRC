package PRC::Email;
use namespace::autoclean;

use Email::SendGrid::V3;
use Template;

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
  my ($self, $assignment, $is_new_user) = @_;
  my $email_id = 1;

  my $sendgrid_api_key = PRC::Secrets->read('SG_API_KEY');
  return undef unless $sendgrid_api_key;

  return undef unless $assignment;
  my $repo = $assignment->repo;
  return undef unless $repo;
  my $user = $assignment->user;
  return undef unless $user;
  my $user_id = $user->user_id;


  my $body;
  my $to = $user->github_email;
  my $subject = 'Your ' . $assignment->month_pretty . ' Assignment';
  my $unsub_link = PRC::Crypt->create_unsubscribe_link($user_id, $email_id);

  my $tt = Template->new({
      INCLUDE_PATH => 'root/static/html/email',
      INTERPOLATE  => 1,
  }) || die "$Template::ERROR\n";

  $tt->process(
    'new-assignment.html',
    {
      unsub_link   => $unsub_link,
      is_new_user  => $is_new_user,
      month_pretty => $assignment->month_pretty,
      user_github_login     => $user->github_login,
      repo_github_html_url  => $repo->github_html_url,
      repo_github_full_name => $repo->github_full_name,
    },
    \$body
  );

  Email::SendGrid::V3->new(api_key => $sendgrid_api_key)
    ->from('"Pull Request Club" <hello@pullrequest.club>')
    ->reply_to('kyzn@cpan.org')
    ->subject($subject)
    ->add_content('text/html', $body)
    ->add_envelope( to => [ $to ] )
    ->send;

  $self->log_email($user, $email_id, $assignment->assignment_id);
}

=head2 send_open_reminder_email

Takes in assignment. Sends open reminder email.
Does no checks for TOS and opt-in (yet).

=cut

sub send_open_reminder_email {
  my ($self, $assignment) = @_;
  my $email_id = 3;

  my $sendgrid_api_key = PRC::Secrets->read('SG_API_KEY');
  return undef unless $sendgrid_api_key;

  return undef unless $assignment;
  my $repo = $assignment->repo;
  return undef unless $repo;
  my $user = $assignment->user;
  return undef unless $user;
  my $user_id = $user->user_id;

  my $body;
  my $to = $user->github_email;
  my $subject = 'Reminder: You have an open assignment';
  my $unsub_link = PRC::Crypt->create_unsubscribe_link($user_id, $email_id);

  my $tt = Template->new({
      INCLUDE_PATH => 'root/static/html/email',
      INTERPOLATE  => 1,
  }) || die "$Template::ERROR\n";

  $tt->process(
    'open-reminder.html',
    {
      unsub_link   => $unsub_link,
      month_pretty => $assignment->month_pretty,
      user_github_login     => $user->github_login,
      repo_github_html_url  => $repo->github_html_url,
      repo_github_full_name => $repo->github_full_name,
    },
    \$body
  );

  Email::SendGrid::V3->new(api_key => $sendgrid_api_key)
    ->from('"Pull Request Club" <hello@pullrequest.club>')
    ->reply_to('kyzn@cpan.org')
    ->subject($subject)
    ->add_content('text/html', $body)
    ->add_envelope( to => [ $to ] )
    ->send;

  $self->log_email($user, $email_id, $assignment->assignment_id);
}

=head2 send_new_feature_email

Takes in an user, sends "new feature" email.
Currently this is the t-shirt email.
Checks for TOS and opt-in.

=cut

sub send_new_feature_email {
  my ($self, $user) = @_;
  my $email_id = 4; # new-feature


  my $sendgrid_api_key = PRC::Secrets->read('SG_API_KEY');
  return undef unless $sendgrid_api_key;

  return undef unless $user;
  return undef unless $user->has_accepted_latest_terms;
  return undef unless $user->is_subscribed_to($email_id);
  my $user_id = $user->user_id;

  my $body;
  my $to = $user->github_email;
  my $subject = 'Pull Request Club T-shirt Survey';
  my $unsub_link = PRC::Crypt->create_unsubscribe_link($user_id, $email_id);

  my $tt = Template->new({
      INCLUDE_PATH => 'root/static/html/email',
      INTERPOLATE  => 1,
  }) || die "$Template::ERROR\n";

  $tt->process(
    'new-feature.html',
    {
      form_link  => PRC::Secrets->read('FORM_LINK'),
      unsub_link => $unsub_link,
      user_github_login => $user->github_login,
    },
    \$body
  );

  Email::SendGrid::V3->new(api_key => $sendgrid_api_key)
    ->from('"Pull Request Club" <hello@pullrequest.club>')
    ->reply_to('kyzn@cpan.org')
    ->subject($subject)
    ->add_content('text/html', $body)
    ->add_envelope( to => [ $to ] )
    ->send;

  $self->log_email($user, $email_id);
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
