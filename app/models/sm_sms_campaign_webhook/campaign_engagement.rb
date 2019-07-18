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
    # @raise [InvalidPayload] when uuid missing from payload
    def event_uuid
      @event_uuid ||= String(
        payload.fetch("uuid") do
          raise InvalidPayload,
                "uuid missing from payload #{payload.inspect}"
        end.freeze
      )
    end

    # @return [String] Campaign engagement event type
    # @raise [InvalidPayload] when type missing from payload
    def event_type
      @event_type ||= String(
        payload.fetch("type") do
          raise InvalidPayload,
                "type missing from payload #{payload.inspect}"
        end.freeze
      )
    end

    # @return [DateTime] Campaign engagement event timestamp
    # @raise [InvalidPayload] when created_at missing from payload
    # @raise [InvalidPayloadValue] when created_at not datetime
    def event_created_at
      @event_created_at ||= begin
        raw_created_at = payload.fetch("created_at") do
          raise InvalidPayload,
                "created_at missing from payload #{payload.inspect}"
        end
        DateTime.parse(raw_created_at).freeze
      end
    rescue ArgumentError
      raise InvalidPayloadValue,
            "created_at has invalid datetime value #{payload.inspect}"
    end

    # @return [Integer] ID of the engaged campaign
    # @raise [InvalidPayload] when campaign id missing from payload
    # @raise [InvalidPayloadValue] when campaign id not numeric
    def campaign_id
      @campaign_id ||= Integer(
        campaign_hash.fetch("id") do
          raise InvalidPayload,
                "campaign id missing from payload #{payload.inspect}"
        end
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
            "campaign id has invalid integer value #{payload.inspect}"
    end

    # @return [String] Keyword of the engaged campaign
    # @raise [InvalidPayload] when campaign keyword missing from payload
    def campaign_keyword
      @campaign_keyword ||= String(
        campaign_hash.fetch("keyword") do
          raise InvalidPayload,
                "campaign keyword missing from payload #{payload.inspect}"
        end.freeze
      )
    end

    # @return [Integer] ID of the engaging phone
    # @raise [InvalidPayload] when phone id missing from payload
    # @raise [InvalidPayloadValue] when phone id not numeric
    def phone_id
      @phone_id ||= Integer(
        phone_hash.fetch("id") do
          raise InvalidPayload,
                "phone id missing from payload #{payload.inspect}"
        end
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
            "phone id has invalid integer value #{payload.inspect}"
    end

    # @return [String] Phone number engaging the campaign
    # @raise [InvalidPayload] when phone number missing from payload
    def phone_number
      @phone_number ||= String(
        phone_hash.fetch("number") do
          raise InvalidPayload,
                "phone number missing from payload #{payload.inspect}"
        end.freeze
      )
    end

    # @return [Integer] ID of campaign engagement state record
    # @raise [InvalidPayload] when phone_campaign_state id missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state id not numeric
    def phone_campaign_state_id
      @phone_campaign_state_id ||= Integer(
        phone_campaign_state_hash.fetch("id") do
          raise InvalidPayload,
                "phone_campaign_state id missing from payload #{payload.inspect}"
        end
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
            "phone_campaign_state id has invalid integer value #{payload.inspect}"
    end

    # @return [TrueClass,FalseClass] Has campaign engagement completed?
    # @raise [InvalidPayload] when phone_campaign_state completed missing from payload
    def phone_campaign_state_completed?
      # Has the boolean value already been assigned?
      if !@phone_campaign_state_completed.nil?
        return @phone_campaign_state_completed
      end

      # Extract the value and memoize it.
      @phone_campaign_state_completed = phone_campaign_state_hash
        .fetch("completed") do
          raise InvalidPayload,
                "phone_campaign_state completed missing from payload #{payload.inspect}"
        end
    end

    # @return [DateTime,NilClass] Timestamp of campaign engagement completion if completed
    # @raise [InvalidPayload] when phone_campaign_state completed_at missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state completed_at not datetime
    def phone_campaign_state_completed_at
      @phone_campaign_state_completed_at ||= begin
        raw_completed_at = phone_campaign_state_hash.fetch("completed_at") do
          raise InvalidPayload,
                "phone_campaign_state completed_at missing from payload #{payload.inspect}"
        end
        DateTime.parse(raw_completed_at).freeze if raw_completed_at
      end
    rescue ArgumentError
      raise InvalidPayloadValue,
            "phone_campaign_state completed_at has invalid datetime value #{payload.inspect}"
    end

    private

    # @return [Hash] Data from campaign engagement payload
    def payload_data
      @payload_data ||= payload.fetch("data", {}).freeze
    end

    # @return [Hash] Campaign hash from payload data
    def campaign_hash
      @campaign_hash ||= payload_data.fetch("campaign", {}).freeze
    end

    # @return [Hash] Phone hash from payload data
    def phone_hash
      @phone_hash ||= payload_data.fetch("phone", {}).freeze
    end

    # @return [Hash] Campaign engagement state hash from payload data
    def phone_campaign_state_hash
      @phone_campaign_state_hash ||= payload_data
        .fetch("phone_campaign_state", {})
        .freeze
    end
  end
end
