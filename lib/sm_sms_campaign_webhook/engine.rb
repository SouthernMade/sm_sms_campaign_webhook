# frozen_string_literal: true

require "rails"

module SmSmsCampaignWebhook
  class Engine < ::Rails::Engine
    isolate_namespace SmSmsCampaignWebhook
    config.generators.api_only = true
  end
end
