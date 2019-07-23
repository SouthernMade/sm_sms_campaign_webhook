# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles campaign engagement payload data modeling and processing.
  class CampaignEngagementOperation
    # @param payload [Hash] Deserialized SMS campaign engagement payload
    # @return [CampaignEngagement] modeled payload
    # @raise [PayloadDispatchError] when not campaign engagement payload
    def self.process(payload:)
      logger.debug "#{name} - Processing campaign engagement payload: #{payload.inspect}"

      if payload.fetch("type") != "campaign.engagement"
        raise PayloadDispatchError,
              "dispatched payload different from campaign.engagement #{payload.inspect}"
      end

      CampaignEngagement.new(payload: payload)
    end

    # @return [Processable] SMS campaign payload processor
    # @see [Processable]
    def self.processor
      @processor ||= DefaultProcessor
    end

    # @return [ActiveSupport::Logger] Abstraction of app logger
    def self.logger
      @logger ||= Rails.logger
    end
    private_class_method :logger
  end
end
