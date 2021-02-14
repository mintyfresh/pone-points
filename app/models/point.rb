# frozen_string_literal: true

# == Schema Information
#
# Table name: points
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  message       :string           not null
#  count         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  deleted_by_id :bigint
#
# Indexes
#
#  index_points_on_deleted_by_id  (deleted_by_id)
#  index_points_on_granted_by_id  (granted_by_id)
#  index_points_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (deleted_by_id => pones.id)
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
class Point < ApplicationRecord
  include SoftDeletable

  attr_readonly :count

  belongs_to :pone, inverse_of: :points
  belongs_to :granted_by, class_name: 'Pone', inverse_of: :granted_points

  validates :message, length: { maximum: 1000 }, presence: true
  validates :count, numericality: { other_than: 0 }

  after_create :increment_pone_points_count
  after_delete :decrement_pone_points_count

  scope :today,  -> { on_day(Date.current) }
  scope :on_day, -> (date) { where(created_at: date.beginning_of_day..date.end_of_day) }

  # @return [String]
  def message_html
    MarkdownService.new.render(message)
  end

private

  # @return [void]
  def increment_pone_points_count
    pone.increment!(:points_count, count, touch: true)
  end

  # @return [void]
  def decrement_pone_points_count
    pone.decrement!(:points_count, count, touch: true)
  end
end
