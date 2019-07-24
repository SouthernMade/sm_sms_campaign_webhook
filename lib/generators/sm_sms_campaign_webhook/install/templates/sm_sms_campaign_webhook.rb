# frozen_string_literal: true

require "sm_sms_campaign_webhook"

SmSmsCampaignWebhook.config do |config|
  # SMS campaign payload processor implementing SmSmsCampaignWebhook::Processable behavior.
  # default: SmSmsCampaignWebhook::DefaultProcessor (raises errors for processing)
  config.processor = SmsPayloadProcessor
end
