require "securerandom"

module Helpers
  # Helpers to provide sample SMS campaign payloads.
  module SmsCampaignPayload
    # @return [String] Campaign engagement payload as JSON
    def campaign_engagement_json(completed: false)
      {
        uuid: SecureRandom.uuid,
        object: "event",
        type: "campaign.engagement",
        created_at: Time.zone.now,
        data: {
          campaign: {
            id: rand(1..100),
            keyword: "KEYWORD"
          },
          phone: {
            id: rand(1..100),
            number: "3335557777"
          },
          phone_campaign_state: {
            id: rand(1..100),
            answers: {},
            completed: completed,
            completed_at: (completed ? Time.zone.now : nil)
          }
        }
      }.to_json
    end

    # @return [Hash] Campaign engagement payload serialized JSON
    def campaign_engagement_hash(completed: false)
      JSON.parse(campaign_engagement_json(completed: completed))
    end
  end
end
