# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles campaign engagement payload data modeling and processing.
  class CampaignEngagementOperation
    # Models the campaign engagement payload and hands of processing
    # of the data to the processor.
    #
    # @param payload [Hash] Deserialized SMS campaign engagement payload
    # @raise [PayloadDispatchError] when not campaign engagement payload
    # @see .processor
    def self.process(payload:)
      logger.debug "#{name} - Processing campaign engagement payload: #{payload.inspect}"

      if payload.fetch("type") != "campaign.engagement"
        raise PayloadDispatchError,
              "dispatched payload different from campaign.engagement #{payload.inspect}"
      end

      campaign_enagement = CampaignEngagement.new(payload: payload)
      processor.process_campaign_engagement(campaign_enagement)
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
