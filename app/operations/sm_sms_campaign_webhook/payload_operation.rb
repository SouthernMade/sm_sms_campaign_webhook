# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles payload data modeling and data processing.
  class PayloadOperation
    # @param payload [Hash] Deserialized payload from SMS campaign service
    # @see ProcessCampaignEngagementJob#perform
    def self.dispatch(payload:)
      logger.debug "#{name} - Dispatching payload: #{payload.inspect}"

      case payload.fetch("type", "unknown")
      when "campaign.engagement"
        ProcessCampaignEngagementJob.perform_later(payload)
      else
        # NOOP - Unsupported event type.
        logger.warn "#{name} - Unsupported event type"
      end
    end

    # @return [ActiveSupport::Logger] Abstraction of app logger
    def self.logger
      @logger ||= Rails.logger
    end
    private_class_method :logger
  end
end
