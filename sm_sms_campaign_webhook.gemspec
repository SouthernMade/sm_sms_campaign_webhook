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
  spec.metadata["changelog_uri"] = "https://github.com/SouthernMade/sm_sms_campaign_webhook/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
end
