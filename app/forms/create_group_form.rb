# frozen_string_literal: true

class CreateGroupForm < ApplicationForm
  # @return [Pone]
  attr_accessor :owner

  attribute :name, :string
  attribute :description, :string

  validates :owner, presence: true
  validates :name, presence: true, length: { maximum: Group::NAME_MAX_LENGTH }
  validates :description, length: { maximum: Group::DESCRIPTION_MAX_LENGTH }

  # @return [Group]
  def perform
    super do
      owner.with_lock do
        enforce_maximum_owned_groups_limit!

        owner.owned_groups.create!(name: name, description: description)
      end
    end
  end

private

  # @return [void]
  def enforce_maximum_owned_groups_limit!
    errors.add(:base, :too_many_owned_groups) and throw(:abort) if owner.owned_groups.count >= 5
  end
end
