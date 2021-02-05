# frozen_string_literal: true

class SignInForm < ApplicationForm
  attribute :name, :string
  attribute :password, :string

  validates :name, :password, presence: true

  # @return [Pone]
  def perform
    super do
      pone = Pone.find_by(name: name)
      errors.add(:base, :incorrect_credentials) && throw(:abort) if pone.nil?

      pone = pone.authenticate(PonePasswordCredential, password)
      errors.add(:base, :incorrect_credentials) && throw(:abort) if pone.nil?

      pone
    end
  end
end
