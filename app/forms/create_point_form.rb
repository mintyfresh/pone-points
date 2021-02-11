# frozen_string_literal: true

class CreatePointForm < ApplicationForm
  # @return [Pone]
  attr_accessor :pone
  # @return [Pone]
  attr_accessor :granted_by

  attribute :count, :integer
  attribute :message, :string

  validates :count, numericality: { greater_than: 0, less_than_or_equal_to: 3 }
  validates :message, presence: true, length: { maximum: 1000 }

  # @return [Point]
  def perform
    super do
      granted_by.with_lock do
        ensure_sufficient_giftable_points_remaining!

        pone.points.create!(count: count, message: message, granted_by: granted_by)
      end
    end
  end

private

  # @return [void]
  def ensure_sufficient_giftable_points_remaining!
    remaining_balance = granted_by.giftable_points_count
    return if remaining_balance >= count

    # Spend bonus points to cover the difference.
    required_bonus = count - remaining_balance
    return if granted_by.remove_bonus_points(required_bonus)

    errors.add(:base, :not_enough_points, remaining: remaining_balance)
    throw(:abort)
  end
end
