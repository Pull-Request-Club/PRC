package PRC;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory
# Authentication: required for authenticating users to site
#        Session: required for having a $c->session
#  State::Cookie: Keep sessionid in a cookie. Hi GDPR!
# Str::Memcached: Store actual session data in memcached.

use Catalyst qw/
  ConfigLoader
  Static::Simple
  Authentication
  Session
  Session::State::Cookie
  Session::Store::Memcached
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in prc.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
  name => 'PRC',
  # Disable deprecated behavior needed by old applications
  disable_component_resolution_regex_fallback => 1,
  enable_catalyst_header => 1, # Send X-Catalyst header
  'Plugin::Session' => { expires => 7776000 }, # 90 days
  authentication => {
    default_realm => 'user',
    realms        => {
      user => {
        credential => {
          class => 'NoPassword',
        },
        store => {
          class      => 'DBIx::Class',
          user_model => 'PRCDB::User',
        },
      }, # user
    }, # realms
  }, # authentication
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

PRC - Catalyst based application

=head1 SYNOPSIS

  script/prc_server.pl

=head1 SEE ALSO

L<PRC::Controller::Root>, L<Catalyst>

=cut

1;
