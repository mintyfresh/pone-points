# frozen_string_literal: true

class CreateGroupWebhookForm < CreateWebhookForm
  validates :event_source, type: { name: 'Group' }

  # @return [Class<Webhook>]
  def webhook_class
    GroupWebhook
  end
end
