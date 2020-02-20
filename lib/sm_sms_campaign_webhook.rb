# frozen_string_literal: true

require "sm_sms_campaign_webhook/engine"
require "sm_sms_campaign_webhook/version"

# Namespace for SMS campaign webhook.
module SmSmsCampaignWebhook
  # @return [SmSmsCampaignWebhook] self for configuration purposes
  def self.config(&block)
    yield self if block
  end

  # @return [String] SMS campaign webhook auth token
  # @raise [MissingConfigError] when ENV does not contain SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN value
  def self.auth_token
    @auth_token ||= ENV.fetch("SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN") {
      raise MissingConfigError,
        "ENV does not contain SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN value"
    }
  end

  # @return [Processable] SMS campaign payload processor used by operations
  def self.processor
    @processor ||= DefaultProcessor
  end

  # @param processor [Processable] Custom SMS campaign payload processor
  # @see Processable
  def self.processor=(processor)
    @processor = processor
  end
end
