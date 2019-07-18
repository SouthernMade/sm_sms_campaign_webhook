RSpec.describe "API webhook", type: :request do
  it "responds wtih success" do
    post "/sms_campaign/api/webhook"
    expect(response).to have_http_status(:no_content)
  end
end
