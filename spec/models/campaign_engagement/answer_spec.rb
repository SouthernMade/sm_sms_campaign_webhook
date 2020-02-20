# frozen_string_literal: true

require "date"

RSpec.describe SmSmsCampaignWebhook::CampaignEngagement::Answer, type: :model do
  describe ".cast" do
    context "when :data param is not present" do
      it "raises an error" do
        expect {
          described_class.cast
        }.to raise_error(ArgumentError)
      end
    end

    context "when data is empty" do
      let(:data) { {} }

      it "returns an empty array" do
        expect(
          described_class.cast(data: data)
        ).to eq([])
      end
    end

    context "when data has one answer" do
      let(:data) do
        campaign_engagement_hash(total_answers: 1).dig(
          "data",
          "phone_campaign_state",
          "answers"
        )
      end

      it "returns array with modeled answer" do
        result = described_class.cast(data: data)
        expect(result).to be_a(Array)
        expect(result.length).to eq(1)
        expect(result[0]).to be_a(described_class)
      end
    end

    context "when data has many answers" do
      let(:data) do
        campaign_engagement_hash(total_answers: 3).dig(
          "data",
          "phone_campaign_state",
          "answers"
        )
      end

      it "returns array with modeled answers sorted by collected_at" do
        result = described_class.cast(data: data)
        expect(result).to be_a(Array)
        expect(result.length).to eq(3)
        expect(result[0]).to be_a(described_class)
        expect(result[1]).to be_a(described_class)
        expect(result[2]).to be_a(described_class)

        expected_order = data
          .map { |field, answer_hash|
            answer_hash.fetch("collected_at")
          }
          .map { |collected_at|
            DateTime.parse(collected_at)
          }
          .sort
        result_order = result.map(&:collected_at)
        expect(result_order).to eq(expected_order)
      end
    end
  end

  let(:instance_params) do
    {
      field: field,
      answer_hash: answer_hash,
    }
  end
  let(:field) { payload.keys.first }
  let(:answer_hash) { payload.fetch(field) }
  let(:payload) do
    campaign_engagement_hash.dig(
      "data",
      "phone_campaign_state",
      "answers"
    )
  end

  subject do
    described_class.new(instance_params)
  end

  describe "attributes" do
    context ":field" do
      it { should respond_to(:field) }
      it { should_not respond_to(:field=) }
    end

    context ":answer_hash" do
      it { should respond_to(:answer_hash) }
      it { should_not respond_to(:answer_hash=) }
    end
  end

  describe "#initialize" do
    context "when :field param is not present" do
      before do
        instance_params.delete(:field)
      end

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "when :answer_hash param is not present" do
      before do
        instance_params.delete(:answer_hash)
      end

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    it "assigns field to @field" do
      expect(subject.field).to eq(field)
    end

    it "assigns answer_hash to @answer_hash" do
      expect(subject.answer_hash).to eq(answer_hash)
    end
  end

  describe "#field" do
    it "freezes the value" do
      expect(subject.field).to be_frozen
    end
  end

  describe "#answer_hash" do
    it "freezes the value" do
      expect(subject.answer_hash).to be_frozen
    end
  end

  describe "#value" do
    context "when answer_hash value is missing" do
      before do
        answer_hash.delete("value")
      end

      it "raises an error" do
        expect {
          subject.value
        }.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when answer_hash value is a string" do
      before do
        answer_hash["value"] = "answer string"
      end

      it "returns answer_hash value as string" do
        expected_result = answer_hash.fetch("value")
        expect(subject.value).to eq(expected_result)
        expect(subject.value).to be_a(String)
      end

      it "freezes the value" do
        expect(subject.value).to be_frozen
      end
    end

    context "when answer_hash value is an email" do
      before do
        answer_hash["value"] = "email@example.com"
      end

      it "returns answer_hash value as string" do
        expected_result = answer_hash.fetch("value")
        expect(subject.value).to eq(expected_result)
        expect(subject.value).to be_a(String)
      end

      it "freezes the value" do
        expect(subject.value).to be_frozen
      end
    end

    context "when answer_hash value is a date" do
      before do
        answer_hash["value"] = "2000-07-04"
      end

      it "returns coerced answer_hash value as date" do
        expected_result = Date.parse(answer_hash.fetch("value"))
        expect(subject.value).to eq(expected_result)
      end

      it "freezes the value" do
        expect(subject.value).to be_frozen
      end
    end

    context "when answer_hash value is a number" do
      before do
        answer_hash["value"] = 42
      end

      it "returns answer_hash value as integer" do
        expected_result = answer_hash.fetch("value")
        expect(subject.value).to eq(expected_result)
        expect(subject.value).to be_a(Integer)
      end

      it "freezes the value" do
        expect(subject.value).to be_frozen
      end
    end

    context "when answer_hash value is boolean" do
      context "when true" do
        before do
          answer_hash["value"] = true
        end

        it "returns true" do
          expect(subject.value).to eq(true)
        end

        it "freezes the value" do
          expect(subject.value).to be_frozen
        end
      end

      context "when false" do
        before do
          answer_hash["value"] = false
        end

        it "returns false" do
          expect(subject.value).to eq(false)
        end

        it "freezes the value" do
          expect(subject.value).to be_frozen
        end
      end
    end

    context "when answer_hash value is us state" do
      before do
        answer_hash["value"] = %w[TN FL NY].sample
      end

      it "returns answer_hash value as string" do
        expected_result = answer_hash.fetch("value")
        expect(subject.value).to eq(expected_result)
        expect(subject.value).to be_a(String)
      end

      it "freezes the value" do
        expect(subject.value).to be_frozen
      end
    end
  end

  describe "#collected_at" do
    context "when answer_hash collected_at is missing" do
      before do
        answer_hash.delete("collected_at")
      end

      it "raises an error" do
        expect {
          subject.collected_at
        }.to raise_error(SmSmsCampaignWebhook::InvalidPayload)
      end
    end

    context "when answer_hash collected_at has unexpected value" do
      before do
        answer_hash["collected_at"] = "collected at"
      end

      it "raises an error" do
        expect {
          subject.collected_at
        }.to raise_error(SmSmsCampaignWebhook::InvalidPayloadValue)
      end
    end

    it "returns coerced answer_hash collected_at" do
      expected_result = DateTime.parse(answer_hash.fetch("collected_at"))
      expect(subject.collected_at).to eq(expected_result)
    end

    it "freezes the value" do
      expect(subject.collected_at).to be_frozen
    end
  end
end
