# frozen_string_literal: true

require "action_controller/metal/http_authentication"

module SmSmsCampaignWebhook
  # General webhook controller configuration.
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate

    protected

    # Verify auth token is present and matches the configured value.
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(token, SmSmsCampaignWebhook.auth_token)
      end
    end
  end
end
