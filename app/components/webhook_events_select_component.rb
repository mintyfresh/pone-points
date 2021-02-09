# frozen_string_literal: true

class WebhookEventsSelectComponent < ApplicationComponent
  # @param webhook [Webhook]
  # @param readonly [Boolean]
  def initialize(webhook:, readonly: false)
    @webhook  = webhook
    @readonly = readonly
  end

  # @param event [String]
  # @return [Boolean]
  def enabled?(event)
    @webhook.events&.include?(event)
  end

  # @param event [String]
  # @return [String]
  def element_id(event)
    "webhook_event_#{event.tr('.', '_')}"
  end

  # @return [String]
  def field_name
    "#{@webhook.model_name.singular}[events][]"
  end
end
