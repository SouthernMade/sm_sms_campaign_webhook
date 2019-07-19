# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/application_controller"

module SmSmsCampaignWebhook
  # API webhook for POST requests from SMS campaign service.
  class WebhookController < ApplicationController
    # POST /api/webhook
    # @see PayloadOperation.cast
    def create
      # Deserialize the payload.
      payload = JSON.parse(request.body.read)
      logger.debug "#{self.class} - Payload: #{payload.inspect}"

      # Cast the payload data with the appropriate data model.
      PayloadOperation.cast(payload: payload)

      head :no_content
    rescue JSON::ParserError => e
      logger.warn "#{self.class} - Bad Request: #{e.class} - #{e}"
      head :bad_request
    end
  end
end
