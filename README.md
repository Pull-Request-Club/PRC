# PullRequest.Club

Sign up to receive monthly GitHub issues as your homework!

## Development

Install CPAN module dependencies:

    cpanm --installdeps .

Building the database:

    sqlite3 prc.db < prc.sql

Adding a new modal:

    script/prc_create.pl model PRCDB DBIC::Schema PRC::Schema create=static components=TimeStamp dbi:SQLite:prc.db on_connect_do="PRAGMA foreign_keys = ON"

Run the app locally:

    script/prc_server.pl -r

Run the app locally AND display running queries:

    DBIC_TRACE=1 script/prc_server.pl -r

Running the app in the cloud:

    script/prc_fastcgi.pl -l /tmp/prc.socket -n 5 -p /tmp/prc.pid -d

Run all tests:

    prove -lmv t/*
