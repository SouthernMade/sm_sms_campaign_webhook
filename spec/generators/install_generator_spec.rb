# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "rails/generators"
require "generators/sm_sms_campaign_webhook/install/install_generator"

RSpec.describe SmSmsCampaignWebhook::Generators::InstallGenerator do
  let(:destination) { Dir.mktmpdir }
  let(:initializer_path) do
    File.join(destination, "config/initializers/sm_sms_campaign_webhook.rb")
  end
  let(:processor_path) do
    File.join(destination, "app/processors/sms_payload_processor.rb")
  end

  before do
    FileUtils.mkdir_p(File.join(destination, "config"))
    File.write(
      File.join(destination, "config/routes.rb"),
      "Rails.application.routes.draw do\nend\n"
    )

    # Generate into a scratch app without the post-install README dump.
    generator = described_class.new([], {}, destination_root: destination)
    allow(generator).to receive(:readme)
    silence_stream($stdout) { generator.invoke_all }
  end

  after do
    SmSmsCampaignWebhook.processor = nil
    Object.send(:remove_const, :SmsPayloadProcessor) if defined?(SmsPayloadProcessor)
    FileUtils.remove_entry(destination)
  end

  it "creates the initializer" do
    expect(File).to exist(initializer_path)
  end

  it "creates the payload processor" do
    expect(File).to exist(processor_path)
  end

  it "mounts the engine in the app routes" do
    expect(File.read(File.join(destination, "config/routes.rb"))).to include(
      %(mount SmSmsCampaignWebhook::Engine => "/sms_campaign")
    )
  end

  describe "generated initializer" do
    let(:prepare_blocks) { [] }

    before do
      allow(Rails.application.config).to receive(:to_prepare) do |&block|
        prepare_blocks << block
      end
    end

    # Initializers run before app/ constants can be autoloaded, so the
    # generated processor must not be referenced while the file loads.
    it "loads before the app processor is defined" do
      expect(defined?(SmsPayloadProcessor)).to be_nil
      expect { load initializer_path }.not_to raise_error
    end

    it "configures the generated processor once the app is prepared" do
      load initializer_path
      load processor_path
      prepare_blocks.each(&:call)

      expect(SmSmsCampaignWebhook.processor).to eq(SmsPayloadProcessor)
    end
  end

  def silence_stream(stream)
    original = stream.dup
    stream.reopen(File::NULL)
    yield
  ensure
    stream.reopen(original)
  end
end
