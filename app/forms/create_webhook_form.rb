# frozen_string_literal: true

# @abstract
class CreateWebhookForm < ApplicationForm
  # @return [Pone]
  attr_accessor :owner
  # @return [Pone, Group]
  attr_accessor :event_source

  attribute :name, :string
  attribute :url, :string
  attribute :events, :string, array: true

  validates :owner, :event_source, presence: true
  validates :name, presence: true, length: { maximum: Webhook::NAME_MAX_LENGTH }
  validates :url, presence: true, url: true
  validates :events, subset: { of: :supported_events }

  # @return [Class]
  def self.policy_class
    WebhookPolicy
  end

  # @return [Webhook]
  def perform
    super do
      webhook_class.create!(owner: owner, event_source: event_source, name: name, url: url, events: events)
    end
  end

  delegate :supported_events, to: :webhook_class

  # @abstract
  # @return [Class<Webhook>]
  def webhook_class
    raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
  end
end
