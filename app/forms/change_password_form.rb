# frozen_string_literal: true

class ChangePasswordForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone

  attribute :old_password, :string
  attribute :new_password, :string
  attribute :new_password_confirmation, :string

  validates :old_password, presence: true
  validates :new_password, password: true, confirmation: true
  validates :new_password_confirmation, presence: true

  # @return [Pone]
  def perform
    super do
      pone = self.pone.authenticate(PonePasswordCredential, old_password)
      errors.add(:old_password, :incorrect) && throw(:abort) if pone.nil?

      pone.credential(PonePasswordCredential).update!(password: new_password)

      pone
    end
  end
end
