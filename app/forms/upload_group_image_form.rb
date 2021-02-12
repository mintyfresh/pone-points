# frozen_string_literal: true

class UploadGroupImageForm < ApplicationForm
  # @return [Group]
  attr_accessor :group
  # @return [ActionDispatch::Http::UploadedFile, nil]
  attr_accessor :image

  validates :image, presence: true

  # @return [Class]
  def self.policy_class
    GroupPolicy
  end

  # @return [Group]
  def perform
    super do
      group.update!(image: image) && group
    end
  end
end
