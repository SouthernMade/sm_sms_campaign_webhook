# frozen_string_literal: true

require "sm_sms_campaign_webhook"

# SmsPayloadProcessor lives in app/processors and is autoloaded, so it cannot be
# referenced while initializers run. to_prepare assigns it once the app is
# ready to autoload, and again after each code reload in development.
Rails.application.config.to_prepare do
  SmSmsCampaignWebhook.config do |config|
    # SMS campaign payload processor implementing SmSmsCampaignWebhook::Processable behavior.
    # default: SmSmsCampaignWebhook::DefaultProcessor (raises errors for processing)
    config.processor = SmsPayloadProcessor
  end
end
