package PRC::Form::ShareEmailAddress;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Field::Role::RequestToken';

use namespace::autoclean;

has '+widget_wrapper' => ( default => 'Bootstrap3' );

has_field '_token' => (
    type => 'RequestToken',
);

has_field 'share_email_user_assignment' => (
    type => 'Checkbox',
    label => 'Visible to users who are the owners of assignment repository.',
);

has_field 'share_email_user_assigned' => (
    type => 'Checkbox',
    label => 'Visible to users who are assigned their repositories..',
);

has_field 'submit_sharing' => (
    type => 'Submit',
    value => 'Save Sharing Details',
    element_attr => {
        class => 'btn btn-success'
    },
);

__PACKAGE__->meta->make_immutable;
1;
