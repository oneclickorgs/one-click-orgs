source 'http://rubygems.org'

gem "bundler", "~>1.10"

gem 'rails', '3.2.22.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'

# mysql2 0.3.17 adds compatibility with MySQL 5.7.
gem "mysql2", "~>0.3.17"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~>3.2.5' # sass-rails 4 requires rails 4
  gem 'uglifier', '~>2.7.0'
  gem 'therubyracer', '~>0.12.1'
end

gem "jquery-rails", "~>3.1.3" # jquery-rails 4.0 requires rails 4
gem "jquery-ui-rails", "~>5.0.0"
gem "haml", "~>4.0.0"
gem "rdiscount", "~>2.1.6"
gem "pdfkit", "~>0.8.2"
gem "daemons", "~>1.1.9"
gem "delayed_job", "~>4.0.0"
gem "delayed_job_active_record", "~>4.0.0"
gem "exception_notification_rails3", "~>1.2.0", :require => 'exception_notifier'
gem "cancan", "~>1.6.7"
gem "state_machine", "~>1.2.0"
gem "fastercsv", "~>1.5.4", :platforms => :ruby_18
gem 'state_machine-audit_trail', '~>0.1.2'
gem 'meekster', :git => "git://github.com/oneclickorgs/meekster.git", :tag => 'v0.0.1'
gem 'pdf_form_filler', '~>0.0.3'
gem 'rticles', '~>0.2.4'
gem 'acts_as_list', "~>0.4.0"
# 1.6.8 includes a security fix. 1.7 drops support for Ruby 1.9.3
gem 'nokogiri', ">=1.6.8", "<1.7"
gem 'mail', '~>2.5.4'

# 11 removes #last_comment method, which rspec-core <3.4.4 uses.
gem "rake", "<11"

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development do
  gem "capistrano", "~>2.14.2"
  gem 'net-ssh', '<3'
  gem "railroad"
  gem 'byebug', platforms: [:ruby_20, :ruby_21, :ruby_22, :ruby_23]
  gem 'pry'
  gem 'parallel_tests'
end

group :development, :test do
  gem "rspec-rails"
  gem 'rspec-activemodel-mocks'
  gem "webrat"
  gem "machinist", :git => "git://github.com/chrismear/machinist.git", :branch => "make_on_has_many"
  gem "faker", '~>1.4.2'
  gem "simplecov", :platforms => :ruby_19
  gem "coveralls", :git => "git://github.com/chrismear/coveralls-ruby.git",
    :branch => "oco", :require => false
  gem "cucumber-rails", "~>1.4.0", :require => nil
  gem "capybara", '~>2.6'
  gem "database_cleaner"
  gem "launchy"
  gem "cucumber-relizy", "~>0.0.2"
  gem "syntax", "~>1.0.0"
  gem "pdf-reader"
  gem "selenium-webdriver"
  gem 'test-unit', '~> 3.0', platform: :ruby_22
end
