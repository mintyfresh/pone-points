# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverWebhookJob, type: :job do
  subject(:job) { described_class.new }

  it 'has webhook delivery enabled during testing' do
    expect(described_class).to be_enabled
  end

  describe '#perform' do
    subject(:perform) { job.perform(webhook, webhook_json) }

    let(:webhook) { create(:pone_webhook) }
    let(:webhook_json) { '{"event":"app.mock.event"}' }

    before(:each) do
      stub_request(:post, webhook.url)
    end

    it 'sends a POST request with the JSON data to the webhook URL' do
      perform
      expect(a_request(:post, webhook.url)
          .with(body: webhook_json)
          .with(headers: { 'Content-Type' => 'application/json' }))
        .to have_been_made.once
    end

    context 'when webhook delivery is disabled' do
      around(:each) do |example|
        Rails.application.config.x.webhooks.enable = false
        example.run
      ensure
        Rails.application.config.x.webhooks.enable = true
      end

      it 'prevents the POST request from being sent' do
        perform
        expect(a_request(:post, webhook.url)).not_to have_been_made
      end
    end
  end
end
