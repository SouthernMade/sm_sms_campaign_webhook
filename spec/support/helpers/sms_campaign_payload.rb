require "securerandom"

module Helpers
  # Helpers to provide sample SMS campaign payloads.
  module SmsCampaignPayload
    # @return [String] Unsupported payload as JSON
    def unsupported_event_json
      {
        uuid: SecureRandom.uuid,
        object: "event",
        type: "unsupported",
        created_at: Time.zone.now
      }.to_json
    end

    # @return [Hash] Unsupported payload deserialized from JSON
    def unsupported_event_hash
      JSON.parse(unsupported_event_json)
    end

    # @return [String] Campaign engagement payload as JSON
    def campaign_engagement_json(completed: false, total_answers: 1)
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
            answers: generate_answers_hash(total_answers),
            completed: completed,
            completed_at: (completed ? Time.zone.now : nil)
          }
        }
      }.to_json
    end

    # @return [Hash] Campaign engagement payload serialized JSON
    def campaign_engagement_hash(completed: false, total_answers: 1)
      JSON.parse(
        campaign_engagement_json(
          completed: completed,
          total_answers: total_answers
        )
      )
    end

    private

    # @param total_entries [Integer]
    # @return [Hash]
    def generate_answers_hash(total_entries)
      Hash[
        (1..total_entries)
          .to_a
          .map do |num|
            ["field#{num}", generate_answer_hash]
          end
      ]
    end

    # @return [Hash]
    def generate_answer_hash
      collection_buffer = (1..30).to_a.sample
      {
        value: [
          "answer string",
          "email@example.com",
          "2000-07-04",
          42,
          true,
          false,
          "TN"
        ].sample,
        collected_at: Time.zone.now - collection_buffer.seconds
      }
    end
  end
end
