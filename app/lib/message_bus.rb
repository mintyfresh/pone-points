# frozen_string_literal: true

class MessageBus
  SUBSCRIPTIONS_PATH = Rails.root.join('config', 'subscriptions.rb').freeze

  # @!scope class
  # @!method instance
  #   @return [MessageBus]
  include Singleton

  # @return [void]
  def self.load_subscribers
    clear_subscribers
    instance.instance_eval(File.read(SUBSCRIPTIONS_PATH), SUBSCRIPTIONS_PATH.to_s, 1)
  end

  # @return [void]
  def self.clear_subscribers
    instance.clear_subscribers
  end

  def initialize
    @subscriptions = []
  end

  # @return [Enumerable]
  def subscriptions
    @subscriptions.to_enum
  end

  # @param subscriber_class [String]
  # @param on [String, Regexp]
  # @return [void]
  def notify(subscriber_class, on:)
    @subscriptions << ActiveSupport::Notifications.subscribe(on) do |event, *, payload|
      subscriber_class.safe_constantize.perform(event, payload)
    end

    true
  end

  # @param subscriber_locator [Symbol, String]
  # @return [void]
  def subscribe(subscriber_locator, **options)
    notify("#{subscriber_locator.to_s.camelize}Subscriber", **options)
  end

  # @return [void]
  def clear_subscribers
    @subscriptions.each do |subscriber|
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end

    @subscriptions.clear

    true
  end
end
