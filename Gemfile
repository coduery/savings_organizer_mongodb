source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '4.0.2'
gem 'webrick', '~> 1.3.1'
gem 'bcrypt-ruby', '3.1.2'

gem 'mongoid', git: 'https://github.com/mongoid/mongoid.git'
gem 'bson_ext'

group :development, :test do
  gem 'rspec-rails', '2.13.1'
  gem 'database_cleaner'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'rack_session_access'
end

gem 'sass-rails', '4.0.1'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'jbuilder', '~> 1.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'rails_12factor', '0.0.2'
end
