# frozen_string_literal: true

class BackgroundSubscriberJob < ApplicationJob
  queue_as :subscribers

  # @param subscriber_class [String]
  # @param event [String]
  # @param payload [Hash]
  def perform(subscriber_class, event, payload)
    subscriber_class.safe_constantize.new(event, payload).perform
  end
end
