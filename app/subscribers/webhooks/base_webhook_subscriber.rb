# frozen_string_literal: true

module Webhooks
  # @abstract
  class BaseWebhookSubscriber < ApplicationSubscriber
    payload_field :occurred_at

    # @return [void]
    def perform
      webhooks.each do |webhook|
        DeliverWebhookJob.perform_later(webhook, webhook_json)
      end
    end

  protected

    # @abstract
    # @return [Pone, Array<Pone>]
    def pones
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end

    # @return [Enumerable<Webhook>]
    def webhooks
      Webhook.where(pone: pones).where_event(event)
    end

    # @abstract
    # @return [String]
    def webhook_json
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end
  end
end
