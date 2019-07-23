# frozen_string_literal: true

require_dependency "sm_sms_campaign_webhook/application_job"

module SmSmsCampaignWebhook
  # Handles campaign engagement payload processing async.
  class ProcessCampaignEngagementJob < ApplicationJob
    # @param payload [Hash] Campaign engagement event payload
    # @see CampaignEngagementOperation.process
    def perform(payload)
      CampaignEngagementOperation.process(payload: payload)
    end
  end
end
