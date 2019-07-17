Rails.application.routes.draw do
  mount SmSmsCampaignWebhook::Engine => "/sms_campaign"
end
