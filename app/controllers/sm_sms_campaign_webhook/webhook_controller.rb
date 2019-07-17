# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/application_controller"

module SmSmsCampaignWebhook
  # API webhook for POST requests from SMS campaign service.
  class WebhookController < ApplicationController
    # POST /api/webhook
    def create
      head :no_content
    end
  end
end
