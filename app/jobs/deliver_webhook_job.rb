# frozen_string_literal: true

class DeliverWebhookJob < ApplicationJob
  queue_as :webhooks

  retry_on Faraday::ConnectionFailed, wait: :exponentially_longer

  # Checks whether environment config has enabled webhook delivery.
  #
  # @return [Boolean]
  def self.enabled?
    Rails.application.config.x.webhooks.enable
  end

  # @param webhook [Webhook]
  # @param webhook_json [String]
  def perform(webhook, webhook_json)
    deliver_webhook(webhook, webhook_json) if self.class.enabled?
  end

private

  # @param webhook [Webhook]
  # @param webhook_json [String]
  # @return [void]
  def deliver_webhook(webhook, webhook_json)
    Faraday.post(webhook.url, webhook_json) do |request|
      request.options.timeout      = 30
      request.options.open_timeout = 15

      request.headers['Content-Type']  = 'application/json'
      request.headers['GPP-Timestamp'] = request_timestamp
      request.headers['GPP-Signature'] = compute_signature(webhook, request)
    end
  end

  # @return [String]
  def request_timestamp
    Time.current.to_i.to_s
  end

  # @param webhook [Webhook]
  # @param request [#body, #headers]
  # @return [String]
  def compute_signature(webhook, request)
    headers = request.headers.sort.map { |pair| pair.join('=') }.join(',')

    OpenSSL::HMAC.hexdigest('SHA256', webhook.signing_key, "POST\n#{request.body}\n#{headers}")
  end
end
