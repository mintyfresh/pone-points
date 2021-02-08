# frozen_string_literal: true

# @abstract
class ApplicationSubscriber
  # @return [String]
  attr_reader :event
  # @return [Hash]
  attr_reader :payload

  # @param name [Symbol, String]
  # @param as [Symbol, String]
  # @return [void]
  def self.payload_field(name, as: name)
    define_method(as) { payload[name] }
  end

  # @param event [String]
  # @param payload [Hash]
  # @return [void]
  def self.perform(event, payload)
    new(event, payload).perform
  end

  # @return [void]
  def self.process_in_background(**options)
    define_singleton_method(:perform) do |event, payload|
      BackgroundSubscriberJob.set(**options).perform_later(name, event, payload)
    end
  end

  # @param event [String]
  # @param payload [Hash]
  def initialize(event, payload)
    @event   = event
    @payload = payload
  end

  # @abstract
  # @return [void]
  def perform
    raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
  end
end
