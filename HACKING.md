# How to hack on One Click Orgs

## Requirements

* Ruby 1.9.2 (recommended) or 1.8.7
* RubyGems ~> 1.3.7
* bundler gem ~> 1.0.0 (install with gem install bundler)
* MySQL, including client libraries (e.g. libmysqlclient-dev on Debian)

Additionally, on Debian:

* ruby1.8-dev (to get mkmf.rb, which is not in the ruby1.8 package)
* libopenssl-ruby1.8
* libxml2
* libxslt
 
### Optional libraries

* [wkhtmltopdf](http://code.google.com/p/wkhtmltopdf/)

## Debian instructions

First obtain a set of required packages from apt:

    $ apt-get install build-essential git-core ruby1.8 ruby1.8-dev rubygems1.8 mysql-server-5.0 libmysqlclient15-dev libxml2 libxml2-dev libxslt1-dev libxslt1.1 libopenssl-ruby1.8

The version of RubyGems in apt is unfortunately out of date. This can be remedied with:

    $ gem install rubygems-update
    $ cd /var/lib/gems/1.8/bin
    $ ./update_rubygems

Now, install required gems:

    $ gem install bundler

## Setup

1.  Grab the source:

        $ git clone git://github.com/oneclickorgs/one-click-orgs.git
        $ cd one-click-orgs

2.  Install the required gems using Bundler:

        $ bundle install  # installs gem system-wide

    or

        $ bundle install --path vendor/bundle # vendors everything, no system gems

3.  Create your local config files:

        $ bundle exec rake oco:generate_config

4.  Set up your database connection settings, by editing config/database.yml as desired.

    If your database user doesn't have CREATE DATABASE permissions, create the databases manually, e.g.:

        $ mysql -u root -p
        mysql> create database one_click_development;
        mysql> create database one_click_test;
        mysql> exit;

5.  (Create and) migrate the database:

        $ bundle exec rake db:setup

## Running

1.  Start the web server:

        $ bundle exec rails server

2.  (Optional) In another shell, start the job server (which sends emails and closes proposals):

        $ script/delayed_job run                # run in foreground
        $ script/delayed_job start              # start as daemon (check log/delayed_job.log)
        $ bundle exec rake jobs:work            # foreground, from rake
        $ bundle exec rake jobs:clear           # clear queue

3.  Visit `http://localhost:3000/`.

You can just choose 'single organisation mode', or if you want to test multi-tenancy mode, you'll need lines in your hosts file which point `yourorganisation.localhost`, etc. to `127.0.0.1`.

## Quickly creating an association

Unless you're working on the founding stage itself, it can be handy to create
an active association to experiment with, without having to walk through all
the founding steps manually.

To do this, run the `oco:dev:create_association` rake task:

  $ bundle exec rake oco:dev:create_association

## Updating

When you pull updates from the repository, you may need to update your gem bundle (if `Gemfile.lock` has changed) and/or migrate your database (if `db/migrate` has changed):

    $ bundle install
    $ bundle exec rake db:migrate

These commands will safely no-op if no changes are necessary.

## Contributing

Before you submit any patches make sure that no tests fail:

      $ bundle exec rake spec
      $ bundle exec rake cucumber

To submit a patch, you have several options:

*   Put your changes in a branch with an appropriate name, and push it to your GitHub repository, and send a pull request to `oneclickorgs`.

*   Open or reply to an issue in the [issue tracker](http://github.com/oneclickorgs/one-click-orgs/issues), and tell us where to find your commits.

*   Send a patch to the [mailing list](http://groups.google.co.uk/group/oneclickorgs-devspace).

## Contact

There is a [mailing list](http://groups.google.co.uk/group/oneclickorgs-devspace) and an IRC channel, [#oneclickorgs on irc.freenode.net](irc://irc.freenode.net/oneclickorgs).
