# frozen_string_literal: true

RSpec.describe SmSmsCampaignWebhook::PayloadOperation do
  describe ".dispatch" do
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
        expect {
          described_class.dispatch(**method_params)
        }.to raise_error(ArgumentError)
      end
    end

    context "when payload is for campaign engagement" do
      let(:payload) do
        campaign_engagement_hash
      end

      it "schedules job to process campaign engagement payload" do
        expect(
          SmSmsCampaignWebhook::ProcessCampaignEngagementJob
        ).to receive(:perform_later).with(payload)
        described_class.dispatch(**method_params)
      end
    end

    context "when payload is for unsupported event" do
      let(:payload) do
        unsupported_event_hash
      end

      it "does not schedule any processing job" do
        expect {
          described_class.dispatch(**method_params)
        }.to_not have_enqueued_job
      end
    end

    context "when payload does not specify type" do
      let(:payload) { {} }

      it "does not schedule any processing job" do
        expect {
          described_class.dispatch(**method_params)
        }.to_not have_enqueued_job
      end
    end
  end
end
