# frozen_string_literal: true

class UploadAvatarForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone
  # @return [ActionDispatch::Http::UploadedFile, nil]
  attr_accessor :avatar

  validates :avatar, presence: true

  # @return [Pone]
  def perform
    super do
      pone.update!(avatar: avatar) && pone
    end
  end
end
