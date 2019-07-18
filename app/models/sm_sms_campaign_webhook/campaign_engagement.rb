# frozen_string_literal: true

require "date"

module SmSmsCampaignWebhook
  # Data model for campaign engagement event from SMS campaign.
  class CampaignEngagement
    attr_reader :payload

    # @param payload [Hash] Campaign engagement event payload
    def initialize(payload)
      @payload = payload.deep_dup.freeze
    end

    # @return [String] Campaign engagement event UUID
    def event_uuid
      @event_uuid ||= payload.fetch("uuid").freeze
    end

    # @return [String] Campaign engagement event type
    def event_type
      @event_type ||= payload.fetch("type").freeze
    end

    # @return [DateTime] Campaign engagement event timestamp
    def event_created_at
      @event_created_at ||= begin
        raw_created_at = payload.fetch("created_at")
        DateTime.parse(raw_created_at).freeze
      end
    end

    # @return [Integer] ID of the engaged campaign
    def campaign_id
      @campaign_id ||= campaign_hash.fetch("id")
    end

    # @return [String] Keyword of the engaged campaign
    def campaign_keyword
      @campaign_keyword ||= campaign_hash.fetch("keyword").freeze
    end

    # @return [String] ID of the engaging phone
    def phone_id
      @phone_id ||= phone_hash.fetch("id")
    end

    # @return [String] Phone number engaging the campaign
    def phone_number
      @phone_number ||= phone_hash.fetch("number").freeze
    end

    # @return [Integer] ID of campaign engagement state record
    def phone_campaign_state_id
      @phone_campaign_state_id ||= phone_campaign_state_hash.fetch("id")
    end

    # @return [TrueClass,FalseClass] Has campaign engagement completed?
    def phone_campaign_state_completed?
      # Has the boolean value already been assigned?
      if !@phone_campaign_state_completed.nil?
        return @phone_campaign_state_completed
      end

      # Extract the value and memoize it.
      @phone_campaign_state_completed = phone_campaign_state_hash
        .fetch("completed")
    end

    # @return [DateTime,NilClass] Timestamp of campaign engagement completion if completed
    def phone_campaign_state_completed_at
      @phone_campaign_state_completed_at ||= begin
        raw_completed_at = phone_campaign_state_hash.fetch("completed_at")
        DateTime.parse(raw_completed_at).freeze if raw_completed_at
      end
    end

    private

    # @return [Hash] Data from campaign engagement payload
    def payload_data
      @payload_data ||= payload.fetch("data").freeze
    end

    # @return [Hash] Campaign hash from payload data
    def campaign_hash
      @campaign_hash ||= payload_data.fetch("campaign").freeze
    end

    # @return [Hash] Phone hash from payload data
    def phone_hash
      @phone_hash ||= payload_data.fetch("phone").freeze
    end

    # @return [Hash] Campaign engagement state hash from payload data
    def phone_campaign_state_hash
      @phone_campaign_state_hash ||= payload_data.fetch("phone_campaign_state")
                                                 .freeze
    end
  end
end
