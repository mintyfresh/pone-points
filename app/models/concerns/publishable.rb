# frozen_string_literal: true

module Publishable
  extend ActiveSupport::Concern

  class_methods do
    # @!method publishes_notifications_on(*events)
    #   @!scope class
    #   @param events [Array<Symbol, String>]
    #   @return [void]
    def publishes_notifications_on(*events)
      events.each do |event|
        after_commit(on: event) { publish_notification(event) }
      end
    end
  end

  # @param event [Symbol, String]
  # @param payload [Hash]
  # @return [void]
  def publish_notification(event, **payload)
    ActiveSupport::Notifications.instrument(
      topic_for_notification(event),
      build_publishable_payload.merge(payload)
    )
  end

protected

  # @param event [Symbol, String]
  # @return [String]
  def topic_for_notification(event)
    "app.#{model_name.plural}.#{event}"
  end

  # @return [Hash]
  def build_publishable_payload
    { model_name.singular.to_sym => self, occurred_at: Time.current }
  end
end
