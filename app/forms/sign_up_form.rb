# frozen_string_literal: true

class SignUpForm < ApplicationForm
  attribute :name, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  validates :name, display_name: true
  validates :password, password: true, confirmation: true
  validates :password_confirmation, presence: true

  # @return [Pone]
  def perform
    super do
      Pone.create!(name: name) do |pone|
        pone.credentials << PonePasswordCredential.new(password: password)
      end
    end
  end
end
