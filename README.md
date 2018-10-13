# PullRequest.Club

Sign up to receive monthly GitHub issues as your homework!

## Development

Building the database:

    sqlite3 prc.db < prc.sql

Adding a new modal:

    script/prc_create.pl model DB DBIC::Schema PRC::Schema create=static dbi:SQLite:prc.db on_connect_do="PRAGMA foreign_keys = ON"

Run the app locally:

    script/prc_server.pl

Running the app in the cloud:

    script/prc_fastcgi.pl -l /tmp/prc.socket -n 5 -p /tmp/prc.pid -d

Run all tests:

    prove -lmv t/*
