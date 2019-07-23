RSpec.describe SmSmsCampaignWebhook do
  describe "VERSION" do
    it "has a version number" do
      expect(described_class::VERSION).to_not be_nil
    end
  end
end
