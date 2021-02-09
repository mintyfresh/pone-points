# frozen_string_literal: true

class WebhookListComponent < ApplicationComponent
  # @param webhooks [Array<Webhook>]
  # @param webhook_url [Proc]
  # @param placeholder [String]
  def initialize(webhooks:, webhook_url:, placeholder: nil)
    @webhooks    = webhooks
    @webhook_url = webhook_url
    @placeholder = placeholder
  end

  # @param webhook [Webhook]
  # @return [String]
  def webhook_url_for(webhook)
    @webhook_url.call(webhook)
  end
end
