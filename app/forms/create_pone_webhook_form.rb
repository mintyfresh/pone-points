# frozen_string_literal: true

class CreatePoneWebhookForm < CreateWebhookForm
  validates :event_source, type: { name: 'Pone' }

  # @return [Class<Webhook>]
  def webhook_class
    PoneWebhook
  end
end
