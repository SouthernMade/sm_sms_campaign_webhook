# frozen_string_literal: true

require "json"
require_dependency "sm_sms_campaign_webhook/application_controller"

module SmSmsCampaignWebhook
  # API webhook for POST requests from SMS campaign service.
  class WebhookController < ApplicationController
    # POST /api/webhook
    # @see DispatchPayloadJob#perform
    def create
      # Deserialize the payload.
      payload = JSON.parse(request.body.read)
      logger.debug "#{self.class} - Payload: #{payload.inspect}"

      # Dispatch the payload to the appropriate payload processor.
      DispatchPayloadJob.perform_later(payload)

      head :no_content
    rescue JSON::ParserError => e
      logger.warn "#{self.class} - Bad Request: #{e.class} - #{e}"
      head :bad_request
    end
  end
end
