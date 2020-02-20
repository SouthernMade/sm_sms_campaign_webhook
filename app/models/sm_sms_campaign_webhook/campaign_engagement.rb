# frozen_string_literal: true

require "date"

module SmSmsCampaignWebhook
  # Data model for campaign engagement event from SMS campaign.
  class CampaignEngagement
    attr_reader :payload

    # @param payload [Hash] Campaign engagement event payload
    def initialize(payload:)
      @payload = payload.deep_dup.freeze
    end

    # @return [String] Campaign engagement event UUID
    # @raise [InvalidPayload] when uuid missing from payload
    def event_uuid
      @event_uuid ||= String(
        payload.fetch("uuid") {
          raise_invalid_payload_for("uuid")
        }.freeze
      )
    end

    # @return [String] Campaign engagement event type
    # @raise [InvalidPayload] when type missing from payload
    def event_type
      @event_type ||= String(
        payload.fetch("type") {
          raise_invalid_payload_for("type")
        }.freeze
      )
    end

    # @return [DateTime] Campaign engagement event timestamp
    # @raise [InvalidPayload] when created_at missing from payload
    # @raise [InvalidPayloadValue] when created_at not datetime
    def event_created_at
      @event_created_at ||= begin
        raw_created_at = payload.fetch("created_at") {
          raise_invalid_payload_for("created_at")
        }
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
        campaign_hash.fetch("id") {
          raise_invalid_payload_for("campaign id")
        }
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
        "campaign id has invalid integer value #{payload.inspect}"
    end

    # @return [String] Keyword of the engaged campaign
    # @raise [InvalidPayload] when campaign keyword missing from payload
    def campaign_keyword
      @campaign_keyword ||= String(
        campaign_hash.fetch("keyword") {
          raise_invalid_payload_for("campaign keyword")
        }.freeze
      )
    end

    # @return [Integer] ID of the engaging phone
    # @raise [InvalidPayload] when phone id missing from payload
    # @raise [InvalidPayloadValue] when phone id not numeric
    def phone_id
      @phone_id ||= Integer(
        phone_hash.fetch("id") {
          raise_invalid_payload_for("phone id")
        }
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
        "phone id has invalid integer value #{payload.inspect}"
    end

    # @return [String] Phone number engaging the campaign
    # @raise [InvalidPayload] when phone number missing from payload
    def phone_number
      @phone_number ||= String(
        phone_hash.fetch("number") {
          raise_invalid_payload_for("phone number")
        }.freeze
      )
    end

    # @return [Integer] ID of campaign engagement state record
    # @raise [InvalidPayload] when phone_campaign_state id missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state id not numeric
    def phone_campaign_state_id
      @phone_campaign_state_id ||= Integer(
        phone_campaign_state_hash.fetch("id") {
          raise_invalid_payload_for("phone_campaign_state id")
        }
      )
    rescue ArgumentError
      raise InvalidPayloadValue,
        "phone_campaign_state id has invalid integer value #{payload.inspect}"
    end

    # @return [TrueClass,FalseClass] Has campaign engagement completed?
    # @raise [InvalidPayload] when phone_campaign_state completed missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state completed is not boolean
    def phone_campaign_state_completed?
      # Has the boolean value already been assigned?
      unless @phone_campaign_state_completed.nil?
        return @phone_campaign_state_completed
      end

      # Extract the value and memoize it.
      @phone_campaign_state_completed = begin
        completed = phone_campaign_state_hash
          .fetch("completed") {
            raise_invalid_payload_for("phone_campaign_state completed")
          }

        # Is this a boolean value?
        if [true, false].none?(completed)
          raise InvalidPayloadValue,
            "phone_campaign_state completed has invalid boolean value #{payload.inspect}"
        end

        completed
      end
    end

    # @return [DateTime,NilClass] Timestamp of campaign engagement completion if completed
    # @raise [InvalidPayload] when phone_campaign_state completed_at missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state completed_at not datetime
    def phone_campaign_state_completed_at
      @phone_campaign_state_completed_at ||= begin
        raw_completed_at = phone_campaign_state_hash.fetch("completed_at") {
          raise_invalid_payload_for("phone_campaign_state completed_at")
        }
        DateTime.parse(raw_completed_at).freeze if raw_completed_at
      end
    rescue ArgumentError
      raise InvalidPayloadValue,
        "phone_campaign_state completed_at has invalid datetime value #{payload.inspect}"
    end

    # @return [Array<Answer>] Modeled campaign engagement answers
    # @raise [InvalidPayload] when phone_campaign_state answers missing from payload
    # @raise [InvalidPayloadValue] when phone_campaign_state answers not hash
    def phone_campaign_state_answers
      @phone_campaign_state_answers ||= begin
        # Extract answers data from payload.
        data = phone_campaign_state_hash.fetch("answers") {
          raise_invalid_payload_for("phone_campaign_state answers")
        }

        # Is this hash data?
        unless data.is_a?(Hash)
          raise InvalidPayloadValue,
            "phone_campaign_state answers has invalid hash value #{payload.inspect}"
        end

        # Cast answers data.
        Answer.cast(data: data).freeze
      end
    end

    # @return [TrueClass,FalseClass] Are any campaign engagement answers present?
    def phone_campaign_state_answers?
      !phone_campaign_state_answers.empty?
    end

    # @param field [String] Answer data to find
    # @return [Answer,NilClass] Modeled answer for field when found
    def answer_for(field:)
      phone_campaign_state_answers.detect do |answer|
        answer.field == field
      end
    end

    private

    # @param attr [String] Expected attribute missing from payload
    def raise_invalid_payload_for(attr)
      raise InvalidPayload, "#{attr} missing from payload #{payload.inspect}"
    end

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
