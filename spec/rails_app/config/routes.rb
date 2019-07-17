Rails.application.routes.draw do
  mount SmSmsCampaignWebhook::Engine => "/sm_sms_campaign_webhook"
end
