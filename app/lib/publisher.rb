# frozen_string_literal: true

module Publisher
  # @param event [Symbol, String]
  # @param payload [Hash]
  # @return [void]
  def publish(event, **payload)
    ActiveSupport::Notifications.instrument(event, { **payload, occurred_at: Time.current })

    Rails.logger.debug { "#{self.class.name} published #{event} => #{payload.keys}" }
  end
end
