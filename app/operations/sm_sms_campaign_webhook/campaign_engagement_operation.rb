# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Handles campaign engagement payload data modeling and processing.
  class CampaignEngagementOperation
    # @param payload [Hash] Deserialized SMS campaign engagement payload
    # @return [CampaignEngagement] modeled payload
    # @raise [PayloadDispatchError] when not campaign engagement payload
    def self.process(payload:)
      if payload.fetch("type") != "campaign.engagement"
        raise PayloadDispatchError,
              "dispatched payload different from campaign.engagement #{payload.inspect}"
      end

      CampaignEngagement.new(payload: payload)
    end
  end
end
