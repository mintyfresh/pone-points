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
      subscriber_class = Pathname.new(filename).relative_path_from(SUBSCRIBERS_PATH).to_s.chomp('.rb')
      subscriber_class = subscriber_class.camelize.safe_constantize

      subscriber_class.subscribed_patterns.each do |pattern|
        instance.add_subscriber(subscriber_class, pattern)
      end
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
