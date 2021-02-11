# frozen_string_literal: true

class CreateApiKeyForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone

  attribute :name, :string
  attribute :description, :string

  validates :name, presence: true, length: { maximum: ApiKey::NAME_MAX_LENGTH }
  validates :description, length: { maximum: ApiKey::DESCRIPTION_MAX_LENGTH }

  # @return [Class]
  def self.policy_class
    ApiKeyPolicy
  end

  # @return [ApiKey]
  def perform
    super do
      pone.api_keys.create!(name: name, description: description)
    end
  end
end
