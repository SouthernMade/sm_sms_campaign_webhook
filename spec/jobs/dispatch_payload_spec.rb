RSpec.describe SmSmsCampaignWebhook::DispatchPayloadJob, type: :job do
  let(:payload) do
    random_sms_campaign_payload
  end

  describe "#perform_later" do
    it "schedules job to dispatch a sms campaign payload" do
      expect do
        described_class.perform_later(payload)
      end.to have_enqueued_job
    end
  end

  describe "#perform_now" do
    it "dispatches a sms campaign payload" do
      expect(SmSmsCampaignWebhook::PayloadOperation).to receive(:dispatch)
        .with(payload: payload)
      described_class.perform_now(payload)
    end
  end
end
