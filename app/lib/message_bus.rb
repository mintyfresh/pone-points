# frozen_string_literal: true

class MessageBus
  SUBSCRIBERS_PATH = Rails.root.join('app', 'subscribers').freeze

  # @!scope class
  # @!method instance
  #   @return [MessageBus]
  include Singleton

  # @return [void]
  def self.load_subscribers
    clear_subscribers

    Dir[SUBSCRIBERS_PATH.join('**', '*_subscriber.rb')].each do |filename|
      subscriber_path = Pathname.new(filename).relative_path_from(SUBSCRIBERS_PATH)
      next if subscriber_path.to_s == 'application_subscriber.rb'

      load_subscriber(subscriber_path)
    end
  end

  # @param subscriber_path [Pathname]
  # @return [void]
  def self.load_subscriber(subscriber_path)
    subscriber_class = subscriber_path.to_s.chomp('.rb')
    subscriber_class = subscriber_class.camelize.safe_constantize

    if subscriber_class.is_a?(Class) && subscriber_class < ApplicationSubscriber
      subscriber_class.subscribed_patterns.each do |pattern|
        instance.add_subscriber(subscriber_class, pattern)
      end
    else
      Rails.logger.debug { "Expected #{subscriber_path} to contain a subscriber, but it did not. Skipping." }
    end
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

  # @param subscriber_class [Class<ApplicationSubscriber>]
  # @param pattern [String, Regexp]
  # @return [void]
  def add_subscriber(subscriber_class, pattern)
    @subscriptions << ActiveSupport::Notifications.subscribe(pattern) do |event, *, payload|
      subscriber_class.perform(event, payload)
    end

    true
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
