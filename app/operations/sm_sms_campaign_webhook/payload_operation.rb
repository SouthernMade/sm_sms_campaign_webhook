# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles payload data modeling and data processing.
  class PayloadOperation
    # @param payload [Hash] Deserialized payload from SMS campaign service
    # @see ProcessCampaignEngagementJob#perform
    def self.dispatch(payload:)
      case payload.fetch("type", "unknown")
      when "campaign.engagement"
        ProcessCampaignEngagementJob.perform_later(payload)
      else
        # NOOP - Unsupported event type.
      end
    end
  end
end
