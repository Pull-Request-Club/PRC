use Test2::V0;
use Catalyst::Test 'PRC';
use PRC::Controller::User;

ok( request('/settings')->is_success, 'Request should succeed' );
ok( request('/my-assignment')->is_success, 'Request should succeed' );
ok( request('/my-repos')->is_success, 'Request should succeed' );
done_testing();
