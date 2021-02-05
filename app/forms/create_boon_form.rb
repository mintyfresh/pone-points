# frozen_string_literal: true

class CreateBoonForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone
  # @return [Pone]
  attr_accessor :granted_by

  attribute :points_count, :integer
  attribute :reason, :string

  validates :points_count, numericality: { greater_than: 0, less_than_or_equal_to: 3 }
  validates :reason, presence: true, length: { maximum: 1000 }

  # @return [Boon]
  def perform
    super do
      granted_by.with_lock do
        ensure_sufficient_grantable_points_remaining!

        pone.boons.create!(points_count: points_count, reason: reason, granted_by: granted_by)
      end
    end
  end

private

  # @return [void]
  def ensure_sufficient_grantable_points_remaining!
    remaining = granted_by.remaining_points_budget
    return if remaining >= points_count

    errors.add(:base, :not_enough_points, remaining: remaining)
    throw(:abort)
  end
end
