package PRC::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

PRC::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 check_admin_status

A private action that can make sure admin
is logged in

=cut

sub check_admin_status : Private {
    my ($self, $c) = @_;
    
    my $user = $c->user;

    unless($user) {
        $c->session->{alert_danger} = 'You need to login first.';
        $c->response->redirect('/', 303);
        $c->detach;
    }

    if($user && $user->is_admin == 0) {
        $c->session->{alert_danger} = 'You need to be admin to access /admin routes';
        $c->response->redirect('/', 303);
        $c->detach;
    }
}

=head2 users
returns all the registered users
=cut

sub users: Path('/admin/users'): Args(0) {
    my ( $self, $c ) = @_;
    $c->forward('check_admin_status');
    my $rs = $c->model('PRCDB::User');
    my @users = $rs->all();
    $c->stash({
        template => 'static/html/admin.html',
        users => \@users,
    });
    $c->detach;
}

=head2 users_data
returns the details about user with user_id=$id
=cut


sub user_data: Path('/admin/users'): Args(1) {
    my ( $self, $c, $id ) = @_;
    $c->forward('check_admin_status');
    my $rs = $c->model('PRCDB::User');
    if(not defined $id) {
        $c->log->debug('id not given');
        $c->response->redirect('/admin/users', 303);
        $c->detach;
    }else {
        my $user = $rs->search({
            user_id => $id
        })->first;
        if($user) {
            $c->stash({
                template => 'static/html/admin.html',
                user => $user,
            });
            $c->detach;
        }else {
            $c->log->debug('user not found');
            $c->response->redirect('/admin/users', 303);
            $c->detach;
        }
    }
}
=encoding utf8


__PACKAGE__->meta->make_immutable;

1;
