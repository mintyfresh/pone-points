# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhooks::PointReceiveWebhookSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.points.create' }
  let(:payload) { { point: point, occurred_at: occurred_at } }
  let(:occurred_at) { Time.current }
  let!(:point) { create(:point) }

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let!(:webhook) { create(:pone_webhook, events: ['app.points.receive'], event_source: point.pone) }

    it 'triggers a webhook delivery job' do
      expect { perform }.to have_enqueued_job(DeliverWebhookJob).once.with(
        webhook,
        include_json(event: 'app.points.receive', occurred_at: occurred_at.as_json, webhook_id: webhook.id)
      )
    end

    it 'includes information about the point in the webhook' do
      expect { perform }.to have_enqueued_job(DeliverWebhookJob).once
        .with(webhook, include_json(point: { id: point.id }))
    end

    it 'does not trigger a webhook if for the pone giving the point' do
      webhook.update!(event_source: point.granted_by)
      expect { perform }.not_to have_enqueued_job(DeliverWebhookJob)
    end
  end
end
