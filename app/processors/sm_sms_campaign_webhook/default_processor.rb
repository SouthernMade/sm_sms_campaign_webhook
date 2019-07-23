# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/processable"

module SmSmsCampaignWebhook
  # Default processor with NOOP implementations.
  # @see Processable
  class DefaultProcessor
    include Processable

    # @param campaign_engagement [CampaignEngagement] modeled payload
    def self.process_campaign_engagement(campaign_engagement)
      logger.debug "#{name} - NOOP campaign engagement processing: #{campaign_engagement.inspect}"
    end

    # @return [ActiveSupport::Logger] Abstraction of app logger
    def self.logger
      @logger ||= Rails.logger
    end
    private_class_method :logger
  end
end
