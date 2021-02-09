# frozen_string_literal: true

class CreatePoneWebhookForm < CreateWebhookForm
  MAX_WEBHOOKS_PER_PONE = 5

  validates :event_source, type: { name: 'Pone' }
  validate  :maximum_webhook_count_is_not_exceeded

  # @return [Class<Webhook>]
  def webhook_class
    PoneWebhook
  end

private

  # @return [void]
  def maximum_webhook_count_is_not_exceeded
    return if event_source.webhooks.count < MAX_WEBHOOKS_PER_PONE

    errors.add(:base, :too_many_webhooks, count: MAX_WEBHOOKS_PER_PONE)
  end
end
