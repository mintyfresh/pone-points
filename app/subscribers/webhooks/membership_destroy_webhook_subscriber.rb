# frozen_string_literal: true

module Webhooks
  class MembershipDestroyWebhookSubscriber < BaseWebhookSubscriber
    subscribe_to 'app.memberships.destroy'

    payload_field :membership

  protected

    # @return [Group]
    def event_source
      membership.group
    end

    # @return [String]
    def webhook_json
      JSON.dump(
        event:       event,
        occurred_at: occurred_at,
        group:       GroupBlueprint.render_as_json(membership.group),
        member:      PoneBlueprint.render_as_json(membership.member)
      )
    end
  end
end
