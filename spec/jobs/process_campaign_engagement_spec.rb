RSpec.describe SmSmsCampaignWebhook::ProcessCampaignEngagementJob, type: :job do
  let(:payload) do
    campaign_engagement_hash
  end

  describe "#perform_later" do
    it "schedules job to process campaign engagement payload" do
      expect do
        described_class.perform_later(payload)
      end.to have_enqueued_job
    end
  end

  describe "#perform_now" do
    it "process campaign engagement payload" do
      expect(SmSmsCampaignWebhook::CampaignEngagementOperation).to receive(:process)
        .with(payload: payload)
      described_class.perform_now(payload)
    end
  end
end
