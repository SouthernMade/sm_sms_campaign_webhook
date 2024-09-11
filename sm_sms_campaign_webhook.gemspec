# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sm_sms_campaign_webhook/version"

Gem::Specification.new do |spec|
  spec.name = "sm_sms_campaign_webhook"
  spec.version = SmSmsCampaignWebhook::VERSION
  spec.license = "MIT"
  spec.summary = "Middleware providing webhook for Southern Made SMS Campaign Engagement."
  spec.description = "Middleware providing webhook for Southern Made SMS Campaign Engagement."
  spec.homepage = "https://github.com/SouthernMade/sm_sms_campaign_webhook"
  spec.authors = ["Cameron Dykes", "Matt Mueller"]
  spec.email = ["cameron@southernmade.com", "matt@southernmade.com"]

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "changelog_uri" => "#{spec.homepage}/blob/develop/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/sm_sms_campaign_webhook/#{spec.version}",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    "{app,config,lib}/**/*",
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md",
    "sm_sms_campaign_webhook.gemspec"
  ]
  spec.require_paths = ["lib"]

  # Required version of Ruby guided by Rails.
  spec.required_ruby_version = ">= 3.0.7"

  # Runtime dependencies.
  spec.add_dependency "rails", [">= 6.0", "< 7.1"]

  # Development + test dependencies.
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec-rails", ">= 5.0"
  spec.add_development_dependency "simplecov", "~> 0.20"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
