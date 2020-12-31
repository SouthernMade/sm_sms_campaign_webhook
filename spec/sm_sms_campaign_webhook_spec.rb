# frozen_string_literal: true

require "securerandom"

RSpec.describe SmSmsCampaignWebhook do
  describe "VERSION" do
    it "has a version number" do
      expect(described_class::VERSION).to_not be_nil
    end
  end

  describe ".config" do
    let(:processor_klass) do
      MockWebhookProcessor
    end

    before do
      @original_processor = described_class.processor
    end

    after do
      described_class.instance_variable_set(:@processor, @original_processor)
    end

    it "does not raise an error without a block" do
      expect {
        described_class.config
      }.to_not raise_error
    end

    it "updates library config values" do
      # Update the config values.
      described_class.config do |config|
        config.processor = processor_klass
      end

      # Verify that the values were updated.
      expect(described_class.processor).to eq(processor_klass)
    end
  end

  describe ".auth_token" do
    context "when SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN env value is present" do
      let(:auth_token) do
        ENV.fetch("SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN")
      end

      it "defaults to SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN env value" do
        expect(described_class.auth_token).to eq(auth_token)
      end
    end

    context "when SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN env value is not present" do
      before do
        @original_auth_token = ENV.delete("SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN")
        described_class.instance_variable_set(:@auth_token, nil)
      end

      after do
        ENV["SM_SMS_CAMPAIGN_WEBHOOK_AUTH_TOKEN"] = @original_auth_token
      end

      it "raises an error" do
        expect {
          described_class.auth_token
        }.to raise_error(described_class::MissingConfigError)
      end
    end
  end

  describe ".processor" do
    it "defaults to default processor" do
      expect(
        described_class.processor
      ).to eq(SmSmsCampaignWebhook::DefaultProcessor)
    end
  end

  describe ".processor=" do
    let(:processor_klass) do
      MockWebhookProcessor
    end

    before do
      @original_processor = described_class.processor
    end

    after do
      described_class.instance_variable_set(:@processor, @original_processor)
    end

    it "updates process config" do
      expect {
        described_class.processor = processor_klass
      }.to change(described_class, :processor).to(processor_klass)
    end
  end
end
