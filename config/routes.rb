# frozen_string_literal: true

SmSmsCampaignWebhook::Engine.routes.draw do
  scope "/api" do
    resources :webhook, only: [:create]
  end
end
