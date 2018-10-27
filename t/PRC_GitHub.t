use Test2::V0;
use PRC::GitHub;
use Sub::Override;
use YAML qw/LoadFile/;

# This is a test suite for our own GitHub library.
# It mocks GitHub responses, so doesn't really talk to GitHub.

# Let's mock reading secrets for all subtests
# So that it's a little faster + we don't depend on file for tests.
my $client_id     = 'mocked_client_id';
my $client_secret = 'mocked_client_secret';
my $yaml_override = Sub::Override->new( 'YAML::LoadFile' => sub {
  { client_id => $client_id, client_secret => $client_secret }
});

subtest authenticate_url_is_correct => sub {
  my $expected = "https://github.com/login/oauth/authorize?scope=user%3Aemail&client_id=$client_id";
  my $got      = PRC::GitHub->authenticate_url;
  is $got, $expected, "Correct authentication URL is returned";
};

$yaml_override->restore;
done_testing();
