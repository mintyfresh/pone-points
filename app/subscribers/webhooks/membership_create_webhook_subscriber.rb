# frozen_string_literal: true

module Webhooks
  class MembershipCreateWebhookSubscriber < BaseWebhookSubscriber
    subscribe_to 'app.memberships.create'

    payload_field :membership

  protected

    # @return [Group]
    def event_source
      membership.group
    end

    # @param webhook [Webhook]
    # @return [String]
    def render_webhook(webhook)
      super(
        webhook,
        group:  GroupBlueprint.render_as_json(membership.group),
        member: PoneBlueprint.render_as_json(membership.member)
      )
    end
  end
end
