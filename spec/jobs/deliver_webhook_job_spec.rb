# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverWebhookJob, type: :job do
  subject(:job) { described_class.new }

  describe '#perform' do
    subject(:perform) { job.perform(webhook, webhook_json) }

    let(:webhook) { create(:webhook) }
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
  end
end
