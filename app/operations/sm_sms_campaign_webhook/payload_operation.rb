# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles payload data modeling and data processing.
  class PayloadOperation
    # @param payload [Hash] Deserialized payload from SMS campaign service
    # @return [CampaignEngagement,NilClass] modeled payload for supported types
    # @see CampaignEngagement
    def self.cast(payload:)
      case payload.fetch("type", "unknown")
      when "campaign.engagement"
        CampaignEngagement.new(payload: payload)
      else
        # NOOP - Unsupported event type.
      end
    end
  end
end
