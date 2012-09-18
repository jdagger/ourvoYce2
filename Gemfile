source 'http://rubygems.org'

gem 'rails', '3.2.6'

gem 'simple_form', '2.0.2'
gem 'country_select'
gem 'simple-navigation'
gem 'client_side_validations'
gem 'flash_messages_helper'

gem 'forgery'

gem 'slim'
#gem 'jquery-tmpl-rails'
gem 'ejs'
gem 'rails-backbone'

gem 'pg'

#Authentication
gem 'devise', "2.1.2"
gem 'omniauth'
gem 'omniauth-facebook'
#gem 'omniauth-identity'

gem 'bcrypt-ruby'

gem 'thin'

gem 'thinking-sphinx', '2.0.10'
gem 'flying-sphinx',   '0.6.1'

gem 'rubyzip'

#gem 'compass','0.12.alpha.0'
gem 'bourbon'

gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'awesome_print'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'twitter-bootstrap-rails', '2.0.7'
end

gem 'jquery-rails'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
#
group :development do
  gem 'heroku', '2.30.1'
  gem 'sqlite3'  #weirdly required for taps to work: http://stackoverflow.com/questions/10723651/heroku-dbpush-gives-me-taps-load-error-no-such-file-to-load-sqlite3, can comment this out when not using taps
  gem 'pry'
  gem 'pry-doc'
  gem 'brakeman' #Security scan
  gem 'taps'
  #gem 'ruby-debug19'
  #gem 'ruby-debug-base19'
  #gem 'ruby-debug-ide19'
end

gem 'therubyracer'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false


  gem 'database_cleaner'
  gem 'rails3-generators'
  gem 'rspec-rails'
  gem 'factory_girl_rails', '3.5.0'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'launchy'
  #gem 'rb-fsevent', :require => false if RUBY_PLATFORM=~ /darwin/i
  gem 'shoulda-matchers'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'spork', '~> 0.9.0.rc'
  gem 'valid_attribute'

  gem 'jasmine'
end
