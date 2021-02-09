# frozen_string_literal: true

module Webhooks
  # @abstract
  class BaseWebhookSubscriber < ApplicationSubscriber
    payload_field :occurred_at

    # @return [void]
    def perform
      webhooks.each do |webhook|
        DeliverWebhookJob.perform_later(webhook, render_webhook(webhook))
      end
    end

  protected

    # @return [String]
    def webhook_event
      event
    end

    # @abstract
    # @return [Webhookable, Array<Webhookable>]
    def event_source
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end

    # @return [Enumerable<Webhook>]
    def webhooks
      Webhook.where(event_source: event_source).where_event(webhook_event)
    end

    # @abstract
    # @param webhook [Webhook]
    # @param attributes [Hash]
    # @return [String]
    def render_webhook(webhook, **attributes)
      JSON.dump(
        event:       webhook_event,
        occurred_at: occurred_at.as_json,
        webhook_id:  webhook.id,
        **attributes
      )
    end
  end
end
