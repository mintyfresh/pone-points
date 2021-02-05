# frozen_string_literal: true

# == Schema Information
#
# Table name: achievements
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string           not null
#  pones_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_achievements_on_name  (name) UNIQUE
#
class Achievement < ApplicationRecord
  has_many :unlocked_achievements, dependent: :destroy, inverse_of: :achievement

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { if: :name_changed? }
  validates :description, length: { maximum: 1000 }
end
