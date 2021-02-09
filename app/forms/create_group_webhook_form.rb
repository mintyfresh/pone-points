# frozen_string_literal: true

class CreateGroupWebhookForm < CreateWebhookForm
  # @return [Class<Webhook>]
  def webhook_class
    GroupWebhook
  end
end
