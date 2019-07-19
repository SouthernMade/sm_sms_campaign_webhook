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

  describe "#payload" do
    it "freezes the value" do
      expect(subject.payload).to be_frozen
    end
  end

  describe "#event_uuid" do
    context "when payload uuid is missing" do
      before do
        payload.delete("uuid")
      end

      it "raises an error" do
        expect do
          subject.event_uuid
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    it "returns payload uuid" do
      expected_result = payload.fetch("uuid")
      expect(subject.event_uuid).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.event_uuid).to be_frozen
    end
  end

  describe "#event_type" do
    context "when payload type is missing" do
      before do
        payload.delete("type")
      end

      it "raises an error" do
        expect do
          subject.event_type
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    it "returns payload type" do
      expected_result = payload.fetch("type")
      expect(subject.event_type).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.event_type).to be_frozen
    end
  end

  describe "#event_created_at" do
    context "when payload created_at is missing" do
      before do
        payload.delete("created_at")
      end

      it "raises an error" do
        expect do
          subject.event_created_at
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when payload created_at has unexpected value" do
      before do
        payload["created_at"] = "created at"
      end

      it "raises an error" do
        expect do
          subject.event_created_at
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns serialized payload created_at" do
      expected_value = DateTime.parse(payload.fetch("created_at"))
      expect(subject.event_created_at).to eq(expected_value)
    end

    it "freezes the value" do
      expect(subject.event_created_at).to be_frozen
    end
  end

  describe "#campaign_id" do
    context "when payload data campaign id is missing" do
      before do
        payload["data"]["campaign"].delete("id")
      end

      it "raises an error" do
        expect do
          subject.campaign_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when payload data campaign id has unexpected value" do
      before do
        payload["data"]["campaign"]["id"] = "campaign id"
      end

      it "raises an error" do
        expect do
          subject.campaign_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns payload data campaign id" do
      expected_result = payload.dig("data", "campaign", "id")
      expect(subject.campaign_id).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.campaign_id).to be_frozen
    end
  end

  describe "#campaign_keyword" do
    context "when payload data campaign keyword is missing" do
      before do
        payload["data"]["campaign"].delete("keyword")
      end

      it "raises an error" do
        expect do
          subject.campaign_keyword
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    it "returns payload data campaign keyword" do
      expected_result = payload.dig("data", "campaign", "keyword")
      expect(subject.campaign_keyword).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.campaign_keyword).to be_frozen
    end
  end

  describe "#phone_id" do
    context "when payload data phone id is missing" do
      before do
        payload["data"]["phone"].delete("id")
      end

      it "raises an error" do
        expect do
          subject.phone_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when payload data phone id has unexpected value" do
      before do
        payload["data"]["phone"]["id"] = "phone id"
      end

      it "raises an error" do
        expect do
          subject.phone_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns payload data phone id" do
      expected_result = payload.dig("data", "phone", "id")
      expect(subject.phone_id).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.phone_id).to be_frozen
    end
  end

  describe "#phone_number" do
    context "when payload data phone number is missing" do
      before do
        payload["data"]["phone"].delete("number")
      end

      it "raises an error" do
        expect do
          subject.phone_number
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    it "returns payload data phone number" do
      expected_result = payload.dig("data", "phone", "number")
      expect(subject.phone_number).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.phone_number).to be_frozen
    end
  end

  describe "#phone_campaign_state_id" do
    context "when payload data phone_campaign_state id is missing" do
      before do
        payload["data"]["phone_campaign_state"].delete("id")
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when payload data phone_campaign_state id has unexpected value" do
      before do
        payload["data"]["phone_campaign_state"]["id"] = "phone_campaign_state id"
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_id
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns payload data phone_campaign_state id" do
      expected_result = payload.dig("data", "phone_campaign_state", "id")
      expect(subject.phone_campaign_state_id).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.phone_campaign_state_id).to be_frozen
    end
  end

  describe "#phone_campaign_state_completed?" do
    context "when payload data phone_campaign_state completed has unexpected value" do
      before do
        payload["data"]["phone_campaign_state"]["completed"] = "completed"
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_completed?
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    context "when payload data phone_campaign_state completed is missing" do
      before do
        payload["data"]["phone_campaign_state"].delete("completed")
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_completed?
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

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

    it "freezes the value" do
      expect(subject.phone_campaign_state_completed?).to be_frozen
    end
  end

  describe "#phone_campaign_state_completed_at" do
    context "when payload data phone_campaign_state completed_at is missing" do
      before do
        payload["data"]["phone_campaign_state"].delete("completed_at")
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_completed_at
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when payload data phone_campaign_state completed_at has unexpected value" do
      before do
        payload["data"]["phone_campaign_state"]["completed_at"] = "completed at"
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_completed_at
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

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

      it "freezes the value" do
        expect(subject.phone_campaign_state_completed_at).to be_frozen
      end
    end
  end

  describe "#phone_campaign_state_answers" do
    context "when phone_campaign_state answers is missing" do
      before do
        payload["data"]["phone_campaign_state"].delete("answers")
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_answers
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when phone_campaign_state answers has unexpected value" do
      before do
        payload["data"]["phone_campaign_state"]["answers"] = "answers"
      end

      it "raises an error" do
        expect do
          subject.phone_campaign_state_answers
        end.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns serialized phone_campaign_state answers" do
      result = subject.phone_campaign_state_answers
      expect(result).to be_a(Array)
      result.each do |serialized_answer|
        expect(serialized_answer).to be_a(described_class::Answer)
      end
    end

    it "freezes the value" do
      expect(subject.phone_campaign_state_answers).to be_frozen
    end
  end
end
