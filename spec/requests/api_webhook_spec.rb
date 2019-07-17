RSpec.describe "API webhook", type: :request do
  it "responds wtih success" do
    post "/sm_sms_campaign_webhook/api/webhook"
    expect(response).to have_http_status(:no_content)
  end
end
