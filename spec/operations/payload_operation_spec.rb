require_relative "../support/helpers/sms_campaign_payload"

RSpec.describe SmSmsCampaignWebhook::PayloadOperation do
  include Helpers::SmsCampaignPayload

  describe ".cast" do
    let(:method_params) do
      {
        payload: payload
      }
    end
    let(:payload) do
      unsupported_event_hash
    end

    context "when :payload param is not present" do
      before do
        method_params.delete(:payload)
      end

      it "raises an error" do
        expect do
          described_class.cast(method_params)
        end.to raise_error(ArgumentError)
      end
    end

    context "when payload is for campaign engagement" do
      let(:payload) do
        campaign_engagement_hash
      end

      it "returns payload modeled as campaign engagement" do
        expect(
          described_class.cast(method_params)
        ).to be_a(SmSmsCampaignWebhook::CampaignEngagement)
      end
    end

    context "when payload is for unsupported event" do
      let(:payload) do
        unsupported_event_hash
      end

      it "returns nil" do
        expect(
          described_class.cast(method_params)
        ).to be_nil
      end
    end

    context "when payload does not specify type" do
      let(:payload) { Hash.new }

      it "returns nil" do
        expect(
          described_class.cast(method_params)
        ).to be_nil
      end
    end
  end
end
