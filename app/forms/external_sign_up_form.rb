# frozen_string_literal: true

class ExternalSignUpForm < ApplicationForm
  attribute :sign_up_token, :string
  attribute :name, :string

  validates :name, display_name: true
  validates :sign_up_token, presence: true

  # @return [Pone]
  def perform
    super do
      ExternalAuthService.new.sign_up(sign_up_token, { name: name })
    end
  end
end
