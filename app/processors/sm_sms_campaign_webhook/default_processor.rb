# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/processable"

module SmSmsCampaignWebhook
  # Default processor with NOOP implementations.
  # @see Processable
  class DefaultProcessor
    include Processable
  end
end
