# frozen_string_literal: true

require "rails/generators/base"

module SmSmsCampaignWebhook
  # Namespace for generators provided by the gem.
  module Generators
    # Installs files to prep an app for SMS campaign webhook.
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      # Copy initializer template to config/initializers
      def copy_initializer
        template "sm_sms_campaign_webhook.rb", "config/initializers/sm_sms_campaign_webhook.rb"
      end

      # Copy processor template to app/processors
      def copy_processor
        template "sms_payload_processor.rb.erb", "app/processors/sms_payload_processor.rb"
      end

      # Mount engine to path in config/routes.rb
      def add_mount_path
        insert_into_file "config/routes.rb",
                         "  mount SmSmsCampaignWebhook::Engine => \"/sms_campaign\"\n",
                         after: "Rails.application.routes.draw do\n"
      end

      # Dump the README for the app developer
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
