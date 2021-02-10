# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhooks::MembershipCreateWebhookSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.memberships.create' }
  let(:payload) { { membership: membership, occurred_at: occurred_at } }
  let(:occurred_at) { Time.current }
  let!(:membership) { create(:membership) }

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let!(:webhook) { create(:group_webhook, events: [event], event_source: membership.group) }

    it 'triggers a webhook delivery job' do
      expect { perform }.to have_enqueued_job(DeliverWebhookJob).once.with(
        webhook,
        include_json(event: event, occurred_at: occurred_at.as_json, webhook_id: webhook.id)
      )
    end

    it 'includes information about the member and group in the webhook' do
      expect { perform }.to have_enqueued_job(DeliverWebhookJob).once
        .with(webhook, include_json(group: { slug: membership.group.slug }, member: { slug: membership.member.slug }))
    end

    it 'matches the webhook JSON schema' do
      expect { perform }.to have_enqueued_job(DeliverWebhookJob).once.with(
        webhook, match_schema('webhooks/app.memberships.create')
      )
    end
  end
end
