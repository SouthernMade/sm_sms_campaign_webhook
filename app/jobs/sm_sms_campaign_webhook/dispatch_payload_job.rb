# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/application_job"

module SmSmsCampaignWebhook
  # Handles SMS campaign payload dispatch to processor async.
  class DispatchPayloadJob < ApplicationJob
    # @param payload [Hash] Deserialized payload from SMS campaign service
    # @see PayloadOperation.dispatch
    def perform(payload)
      PayloadOperation.dispatch(payload: payload)
    end
  end
end
