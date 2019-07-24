RSpec.describe SmSmsCampaignWebhook do
  describe "VERSION" do
    it "has a version number" do
      expect(described_class::VERSION).to_not be_nil
    end
  end

  describe ".config" do
    let(:processor_klass) do
      class MockProcessor
        include SmSmsCampaignWebhook::Processable
      end
      MockProcessor
    end

    before do
      @original_processor = described_class.processor
    end

    after do
      described_class.instance_variable_set(:@processor, @original_processor)
    end

    it "does not raise an error without a block" do
      expect do
        described_class.config
      end.to_not raise_error
    end

    it "updates library config values" do
      # Update the config values.
      described_class.config do |config|
        config.processor = processor_klass
      end
      
      # Verify that the values were updated.
      expect(described_class.processor).to eq(processor_klass)
    end
  end

  describe ".processor" do
    it "defaults to default processor" do
      expect(
        described_class.processor
      ).to eq(SmSmsCampaignWebhook::DefaultProcessor)
    end
  end

  describe ".processor=" do
    let(:processor_klass) do
      class MockProcessor
        include SmSmsCampaignWebhook::Processable
      end
      MockProcessor
    end

    before do
      @original_processor = described_class.processor
    end

    after do
      described_class.instance_variable_set(:@processor, @original_processor)
    end

    it "updates process config" do
      expect do
        described_class.processor = processor_klass
      end.to change(described_class, :processor).to(processor_klass)
    end
  end
end
