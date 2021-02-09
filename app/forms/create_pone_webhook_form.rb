# frozen_string_literal: true

class CreatePoneWebhookForm < CreateWebhookForm
  # @return [Class<Webhook>]
  def webhook_class
    PoneWebhook
  end
end
