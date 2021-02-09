# frozen_string_literal: true

class JoinGroupForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone
  # @return [Group]
  attr_accessor :group

  validates :pone, :group, presence: true

  # @return [Membership]
  def perform
    super do
      group.add_member(pone)
    end
  end
end
