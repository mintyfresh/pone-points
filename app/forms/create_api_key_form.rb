# frozen_string_literal: true

class CreateApiKeyForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone

  attribute :name, :string
  attribute :description, :string

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }

  # @return [Point]
  def perform
    super do
      pone.api_keys.create!(name: name, description: description)
    end
  end
end
