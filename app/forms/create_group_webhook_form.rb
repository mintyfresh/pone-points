# frozen_string_literal: true

class CreateGroupWebhookForm < CreateWebhookForm
  MAX_WEBHOOKS_PER_GROUP = 25

  validates :event_source, type: { name: 'Group' }
  validate  :maximum_webhook_count_is_not_exceeded

  # @return [Class<Webhook>]
  def webhook_class
    GroupWebhook
  end

private

  # @return [void]
  def maximum_webhook_count_is_not_exceeded
    return if event_source.webhooks.count < MAX_WEBHOOKS_PER_GROUP

    errors.add(:base, :too_many_webhooks, count: MAX_WEBHOOKS_PER_GROUP)
  end
end
