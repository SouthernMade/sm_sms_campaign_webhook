RSpec.shared_examples "implementation of processable" do
  describe ".process_campaign_engagement" do
    let(:campaign_engagement) do
      SmSmsCampaignWebhook::CampaignEngagement.new(payload: payload)
    end
    let(:payload) do
      campaign_engagement_hash
    end

    it "raises an error without any arguments" do
      expect do
        described_class.process_campaign_engagement
      end.to raise_error(ArgumentError)
    end

    it "does not raise an error" do
      expect do
        described_class.process_campaign_engagement(campaign_engagement)
      end.to_not raise_error
    end
  end
end
