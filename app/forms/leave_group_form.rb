# frozen_string_literal: true

class LeaveGroupForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone
  # @return [Group]
  attr_accessor :group

  validates :pone, :group, presence: true
  validate  :pone_is_not_group_owner

  # @return [Membership]
  def perform
    super do
      group.remove_member(pone)
    end
  end

private

  # @return [void]
  def pone_is_not_group_owner
    errors.add(:base, :cannot_leave_owned_group) if pone == group.owner
  end
end
