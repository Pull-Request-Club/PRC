use Test2::V0;
use PRC::GitHub;
use Sub::Override;

# This is a test suite for our own GitHub library.
# It mocks GitHub responses, so doesn't really talk to GitHub.

# Let's mock reading secrets for all subtests
# So that it's a little faster + we don't depend on file for tests.
my $override = Sub::Override->new( 'PRC::Secrets::read' => sub { 'mock_secret' });

subtest authenticate_url_is_correct => sub {
  my $expected = "https://github.com/login/oauth/authorize?scope=user%3Aemail&client_id=mock_secret";
  my $got      = PRC::GitHub->authenticate_url;
  is $got, $expected, "Correct authentication URL is returned";
};

$override->restore;
done_testing();
