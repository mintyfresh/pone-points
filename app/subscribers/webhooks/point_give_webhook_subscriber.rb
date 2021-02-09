# frozen_string_literal: true

module Webhooks
  class PointGiveWebhookSubscriber < BaseWebhookSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [Array<Pone, Group>]
    def event_source
      [point.granted_by, *point.granted_by.groups]
    end

    # @return [String]
    def webhook_event
      'app.points.give'
    end

    # @param webhook [Webhook]
    # @return [String]
    def render_webhook(webhook)
      super(webhook, point: PointBlueprint.render_as_json(point))
    end
  end
end
