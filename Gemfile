source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# JWT for token based authentication
gem 'acts-as-taggable-on', '~> 9.0'
gem 'bugsnag'
gem 'carrierwave', '~> 2.0'
gem 'devise'
gem 'devise-jwt', '~> 0.10.0'
gem 'fog-aws'
gem 'geocoder'
gem 'jwt'
gem 'kaminari'
gem 'ransack'
gem 'rmagick'

gem 'google_maps_service_ruby'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'standard'
  gem 'standard'
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  gem 'hirb'
  gem 'spring'
  # n + 1 query detection:
  gem 'bullet'
end
