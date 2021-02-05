# frozen_string_literal: true

# == Schema Information
#
# Table name: boons
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  reason        :string
#  points_count  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_boons_on_granted_by_id  (granted_by_id)
#  index_boons_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
class Boon < ApplicationRecord
  attr_readonly :points_count

  belongs_to :pone, inverse_of: :boons
  belongs_to :granted_by, class_name: 'Pone', inverse_of: :granted_boons

  validates :reason, length: { maximum: 1000 }
  validates :points_count, numericality: { other_than: 0 }

  after_create :increment_pone_points_count
  after_destroy :decrement_pone_points_count

  scope :today, -> { where(created_at: Date.current..) }

private

  # @return [void]
  def increment_pone_points_count
    pone.increment!(:points_count, points_count, touch: true)
  end

  # @return [void]
  def decrement_pone_points_count
    pone.decrement!(:points_count, points_count, touch: true)
  end
end
