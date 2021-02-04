# frozen_string_literal: true

# == Schema Information
#
# Table name: boons
#
#  id           :bigint           not null, primary key
#  pone_id      :bigint           not null
#  granted_by   :string           not null
#  message_link :string
#  reason       :string
#  points_count :integer          not null
#  occurred_at  :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_boons_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
class Boon < ApplicationRecord
  attr_readonly :points_count

  belongs_to :pone, inverse_of: :boons

  validates :granted_by, presence: true, length: { maximum: 50 }
  validates :message_link, :reason, length: { maximum: 1000 }
  validates :points_count, numericality: { other_than: 0 }
  validates :occurred_at, presence: true

  after_create :increment_pone_points_count
  after_destroy :decrement_pone_points_count

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
