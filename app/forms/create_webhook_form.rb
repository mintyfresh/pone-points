# frozen_string_literal: true

class CreateWebhookForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone

  attribute :name, :string
  attribute :url, :string
  attribute :events, :string, array: true

  validates :name, presence: true, length: { maximum: Webhook::NAME_MAX_LENGTH }
  validates :url, presence: true, url: true
  validates :events, subset: { of: Webhook::SUPPORTED_EVENTS }

  # @return [Webhook]
  def perform
    super do
      pone.webhooks.create!(name: name, url: url, events: events)
    end
  end
end
