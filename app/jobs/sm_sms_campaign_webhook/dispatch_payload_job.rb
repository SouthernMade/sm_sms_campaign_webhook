# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/application_job"

module SmSmsCampaignWebhook
  # Handles SMS campaign payload dispatch to processor async.
  class DispatchPayloadJob < ApplicationJob
    # @param payload [Hash] Deserialized payload from SMS campaign service
    # @see PayloadOperation.cast
    def perform(payload)
      PayloadOperation.cast(payload: payload)
    end
  end
end
