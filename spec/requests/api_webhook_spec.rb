RSpec.describe "API webhook", type: :request do
  let(:headers) do
    {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  context "without any payload" do
    it "responds with bad request" do
      post "/sms_campaign/api/webhook", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "without json payload" do
    let(:headers) do
      {
        "Accept" => "*/*"
      }
    end
    let(:payload) do
      {q: "not json"}
    end

    it "responds with bad request" do
      post "/sms_campaign/api/webhook", headers: headers, params: payload
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "with unsupported payload" do
    let(:payload) do
      unsupported_event_json
    end

    it "schedules job to dispatch the payload" do
      payload_hash = JSON.parse(payload)
      expect(
        SmSmsCampaignWebhook::DispatchPayloadJob
      ).to receive(:perform_later).with(payload_hash)
      post "/sms_campaign/api/webhook", headers: headers, params: payload
    end

    it "responds with success" do
      post "/sms_campaign/api/webhook", headers: headers, params: payload
      expect(response).to have_http_status(:no_content)
    end
  end

  context "with campaign engagement payload" do
    let(:payload) do
      campaign_engagement_json
    end

    it "schedules job to dispatch the payload" do
      payload_hash = JSON.parse(payload)
      expect(
        SmSmsCampaignWebhook::DispatchPayloadJob
      ).to receive(:perform_later).with(payload_hash)
      post "/sms_campaign/api/webhook", headers: headers, params: payload
    end

    it "responds with success" do
      post "/sms_campaign/api/webhook", headers: headers, params: payload
      expect(response).to have_http_status(:no_content)
    end
  end
end
