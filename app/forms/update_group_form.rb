# frozen_string_literal: true

class UpdateGroupForm < ApplicationForm
  # @return [Group]
  attr_accessor :group

  attribute :description, :string

  validates :description, length: { maximum: Group::DESCRIPTION_MAX_LENGTH }

  # @param group [Group]
  # @return [UpdateGroupForm]
  def self.build(group)
    new(group: group, description: group.description)
  end

  # @return [Class]
  def self.policy_class
    GroupPolicy
  end

  # @return [Group]
  def perform
    super do
      group.update!(description: description) && group
    end
  end
end
