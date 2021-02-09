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

    # @return [String]
    def webhook_json
      JSON.dump(
        event:       webhook_event,
        occurred_at: occurred_at,
        point:       PointBlueprint.render(point)
      )
    end
  end
end
