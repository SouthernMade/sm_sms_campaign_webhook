# frozen_string_literal: true

module SmSmsCampaignWebhook
  # Define behavior that SMS campaign payload processors must implement.
  module Processable
    extend ActiveSupport::Concern

    class_methods do
      # Campaign engagement operation sends modeled campaign engagement payload
      # to this method for applying business logic. Implementors should define
      # the app behavior to properly handle this data.
      #
      # @param campaign_engagement [CampaignEngagement] modeled payload
      # @raise [NotImplementedError] requiring implementing class to define behavior
      def process_campaign_engagement(campaign_engagement)
        raise NotImplementedError,
          "#{self.class} must implement .process_campaign_engagement receiving campaign_engagement param"
      end
    end
  end
end
