lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sm_sms_campaign_webhook/version"

Gem::Specification.new do |spec|
  spec.name          = "sm_sms_campaign_webhook"
  spec.version       = SmSmsCampaignWebhook::VERSION
  spec.authors       = ["Cameron Dykes", "Matt Mueller"]
  spec.email         = ["cameron@southernmade.com", "matt@southernmade.com"]

  spec.summary       = %q{Middleware providing webhook for Southern Made SMS Campaign Engagement.}
  spec.homepage      = "https://github.com/SouthernMade/sm_sms_campaign_webhook"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/SouthernMade/sm_sms_campaign_webhook"
  spec.metadata["changelog_uri"] = "https://github.com/SouthernMade/sm_sms_campaign_webhook/blob/develop/CHANGELOG.md"

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
  spec.required_ruby_version = "~> 2.5"

  # Runtime dependencies.
  spec.add_dependency "rails", [">= 5.2.3", "< 6.1"]

  # Development + test dependencies.
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec-rails", "~> 3.8"
  spec.add_development_dependency "simplecov", "~> 0.17"
  spec.add_development_dependency "yard", "~> 0.9"
end
