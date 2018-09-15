use strict;
use warnings;
use Test::More;


use Catalyst::Test 'PRC';
use PRC::Controller::Callback;

ok( request('/callback')->is_success, 'Request should succeed' );
done_testing();
