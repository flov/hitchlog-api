source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

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

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "dotenv-rails"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "standard"
  gem "faker"
  gem "spring-commands-rspec"
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
  gem "solargraph"
  gem "hirb"
end

gem "devise-jwt", "~> 0.10.0"
