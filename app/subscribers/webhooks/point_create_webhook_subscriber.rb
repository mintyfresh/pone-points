# frozen_string_literal: true

module Webhooks
  class PointCreateWebhookSubscriber < BaseWebhookSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [Array<Pone, Group>]
    def event_source
      [point.pone, point.granted_by, *point.pone.groups, *point.granted_by.groups]
    end

    # @return [String]
    def webhook_json
      PointBlueprint.render(point, view: :webhook, event: event, occurred_at: occurred_at)
    end
  end
end
