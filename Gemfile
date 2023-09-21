source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "bootsnap", require: false
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bcrypt", "~> 3.1.7"
# JWT for token based authentication
gem "jwt"
gem "ransack"
gem "devise"
gem "kaminari"
gem "acts-as-taggable-on", "~> 9.0"
gem "bugsnag"
gem "carrierwave", "~> 2.0"
gem "fog-aws"
gem "rmagick"
gem "devise-jwt", "~> 0.10.0"
gem "geocoder"

gem "google_maps_service_ruby"

group :development, :test do
  gem "dotenv-rails"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "standard"
  gem "faker"
  gem "spring-commands-rspec"
  gem "pry"
end

group :test do
  gem "simplecov", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
  gem "solargraph"
  gem "hirb"
  # n + 1 query detection:
  gem "bullet"
end
