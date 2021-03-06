# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../rails_app/config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

# Require spec/support files
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

# Set expected lib related values.
ENV["SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN"] = SecureRandom.hex(64)

RSpec.configure do |config|
  # Mix custom helpers in to tests.
  config.include Helpers::SmsCampaignPayload

  # Set ActiveJob adapter to test.
  ActiveJob::Base.queue_adapter = :test

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
