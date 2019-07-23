RSpec.describe SmSmsCampaignWebhook::CampaignEngagementOperation do
  describe ".process" do
    let(:method_params) do
      {
        payload: payload
      }
    end
    let(:payload) do
      campaign_engagement_hash
    end

    context "when :payload param is not present" do
      before do
        method_params.delete(:payload)
      end

      it "raises an error" do
        expect do
          described_class.process(method_params)
        end.to raise_error(ArgumentError)
      end
    end

    context "when payload is not for campaign engagement" do
      before do
        payload["type"] = "unknown"
      end

      it "raises an error" do
        expect do
          described_class.process(method_params)
        end.to raise_error(SmSmsCampaignWebhook::PayloadDispatchError)
      end
    end

    it "returns payload modeled as campaign engagement" do
      expect(
        described_class.process(method_params)
      ).to be_a(SmSmsCampaignWebhook::CampaignEngagement)
    end
  end

  describe ".processor" do
    it "returns default processor" do
      expect(described_class.processor).to eq(
        SmSmsCampaignWebhook::DefaultProcessor
      )
    end
  end
end
