Bugsnag.configure do |config|
  config.api_key = ENV["BUGSNAG"]
  config.enabled_release_stages = ["production"]
end
