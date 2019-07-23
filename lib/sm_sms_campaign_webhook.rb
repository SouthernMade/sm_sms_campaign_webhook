# frozen_string_literal: true

require "sm_sms_campaign_webhook/engine"
require "sm_sms_campaign_webhook/version"

# Namespace for SMS campaign webhook.
module SmSmsCampaignWebhook
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
