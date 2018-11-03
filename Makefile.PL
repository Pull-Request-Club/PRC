#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'PRC';
all_from 'lib/PRC.pm';

requires 'Catalyst::Runtime' => '5.90118';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Helper';
requires 'Catalyst::Helper::View::TT';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::Memcached';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Catalyst::Plugin::Unicode';
requires 'DBIx::Class::Schema::Loader';
requires 'DBIx::Class::TimeStamp';
requires 'FCGI';
requires 'FCGI::ProcManager';
requires 'HTTP::Server::Simple';
requires 'HTML::FormHandler';
requires 'JSON::XS';
requires 'LWP::UserAgent';
requires 'Moose';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';
requires 'Task::Catalyst::Tutorial';
requires 'Test2::V0';
requires 'WWW::Mechanize';
requires 'YAML';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
