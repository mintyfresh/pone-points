# frozen_string_literal: true

module Webhooks
  class PointCreateWebhookSubscriber < BaseWebhookSubscriber
    payload_field :point

  protected

    # @return [Array<Pone>]
    def pones
      [point.pone, point.granted_by]
    end

    # @return [String]
    def webhook_json
      PointBlueprint.render(point, view: :webhook, event: event, occurred_at: occurred_at)
    end
  end
end
