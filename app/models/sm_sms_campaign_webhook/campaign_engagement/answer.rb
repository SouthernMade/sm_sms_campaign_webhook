# frozen_string_literal: true

require "date"

module SmSmsCampaignWebhook
  class CampaignEngagement
    # Data model for campaign engagement answer data.
    class Answer
      # @param data [Hash] Answers from payload
      # @return [Array<Answer>] Modeled answer data sorted by collected_at
      def self.cast(data:)
        data.map do |field, answer_hash|
          new(field: field, answer_hash: answer_hash)
        end.sort_by(&:collected_at)
      end

      attr_reader :field,
                  :answer_hash

      # @param field [String] Field describing the answer
      # @param answer_hash [Hash] Answer data from payload
      def initialize(field:, answer_hash:)
        @field = String(field)
        @answer_hash = answer_hash.freeze
      end

      # Collected answer could be many different value types.
      #
      # The SMS campaign service collects answers of type:
      # string, email, date, number, boolean, us_state
      #
      # The possible types are from SMS campaign service perspective.
      # They are coerced to the appropriate type in Ruby.
      #
      # @return [String,Integer,Date,TrueClass,FalseClass] Coerced answer
      # @raise [InvalidPayload] when value is missing from answer_hash
      def value
        # Could be boolean so cannot rely on double pipe assignment guard.
        if !@value.nil?
          return @value
        end

        # Extract the value and memoize it.
        @value = begin
         raw_value = answer_hash.fetch("value") do
           raise InvalidPayload,
                 "value missing from answer_hash #{answer_hash.inspect}"
         end.freeze

         # Attempt to parse date value falling back to raw value.
         Date.strptime(raw_value, "%Y-%m-%d").freeze rescue raw_value
        end
      end

      # @return [DateTime] Timestamp of answer value collection
      # @raise [InvalidPayload] when collected_at missing from answer_hash
      # @raise [InvalidPayloadValue] when collected_at not datetime
      def collected_at
        @collected_at ||= begin
          raw_collected_at = answer_hash.fetch("collected_at") do
            raise InvalidPayload,
                  "collected_at missing from answer_hash #{answer_hash.inspect}"
          end
          DateTime.parse(raw_collected_at).freeze
        end
      rescue ArgumentError
        raise InvalidPayloadValue,
              "collected_at has invalid datetime value #{answer_hash.inspect}"
      end
    end
  end
end
