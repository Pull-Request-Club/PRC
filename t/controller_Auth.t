use Test2::V0;

use Catalyst::Test 'PRC';
use PRC::Controller::Auth;

ok( request('/login')->is_success, 'Request should succeed' );
ok( request('/logout')->is_success, 'Request should succeed' );
ok( request('/callback')->is_success, 'Request should succeed' );
done_testing();
