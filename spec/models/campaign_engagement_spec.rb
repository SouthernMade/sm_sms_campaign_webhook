require "date"
require_relative "../support/helpers/sms_campaign_payload"

RSpec.describe SmSmsCampaignWebhook::CampaignEngagement, type: :model do
  include Helpers::SmsCampaignPayload

  let(:payload) do
    campaign_engagement_hash
  end

  subject { described_class.new(payload) }

  describe "attributes" do
    context ":payload" do
      it { should respond_to(:payload) }
      it { should_not respond_to(:payload=) }
    end
  end

  describe "#initialize" do
    it "assigns param to @payload" do
      expect(subject.payload).to eq(payload)
    end
  end

  describe "#event_uuid" do
    it "returns payload uuid" do
      expected_result = payload.fetch("uuid")
      expect(subject.event_uuid).to eq(expected_result)
    end
  end

  describe "#event_type" do
    it "returns payload type" do
      expected_result = payload.fetch("type")
      expect(subject.event_type).to eq(expected_result)
    end
  end

  describe "#event_created_at" do
    it "returns serialized payload created_at" do
      expected_value = DateTime.parse(payload.fetch("created_at"))
      expect(subject.event_created_at).to eq(expected_value)
    end
  end

  describe "#campaign_id" do
    it "returns payload data campaign id" do
      expected_result = payload.dig("data", "campaign", "id")
      expect(subject.campaign_id).to eq(expected_result)
    end
  end

  describe "#campaign_keyword" do
    it "returns payload data campaign keyword" do
      expected_result = payload.dig("data", "campaign", "keyword")
      expect(subject.campaign_keyword).to eq(expected_result)
    end
  end

  describe "#phone_id" do
    it "returns payload data phone id" do
      expected_result = payload.dig("data", "phone", "id")
      expect(subject.phone_id).to eq(expected_result)
    end
  end

  describe "#phone_number" do
    it "returns payload data phone number" do
      expected_result = payload.dig("data", "phone", "number")
      expect(subject.phone_number).to eq(expected_result)
    end
  end

  describe "#phone_campaign_state_id" do
    it "returns payload data phone_campaign_state id" do
      expected_result = payload.dig("data", "phone_campaign_state", "id")
      expect(subject.phone_campaign_state_id).to eq(expected_result)
    end
  end

  describe "#phone_campaign_state_answers"

  describe "#phone_campaign_state_completed?" do
    context "when phone_campaign_state completed is false" do
      let(:payload) do
        campaign_engagement_hash(completed: false)
      end

      it "returns false" do
        expect(subject.phone_campaign_state_completed?).to eq(false)
      end
    end

    context "when phone_campaign_state completed is true" do
      let(:payload) do
        campaign_engagement_hash(completed: true)
      end

      it "returns true" do
        expect(subject.phone_campaign_state_completed?).to eq(true)
      end
    end
  end

  describe "#phone_campaign_state_completed_at" do
    context "when phone_campaign_state completed_at is not present" do
      let(:payload) do
        campaign_engagement_hash(completed: false)
      end

      it "returns nil" do
        expect(subject.phone_campaign_state_completed_at).to be_nil
      end
    end

    context "when phone_campaign_state completed_at is present" do
      let(:payload) do
        campaign_engagement_hash(completed: true)
      end

      it "returns serialized payload data phone_campaign_state completed_at" do
        expected_result = DateTime.parse(
          payload.dig("data", "phone_campaign_state", "completed_at")
        )
        expect(subject.phone_campaign_state_completed_at).to eq(expected_result)
      end
    end
  end
end
