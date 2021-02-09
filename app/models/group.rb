# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id            :bigint           not null, primary key
#  owner_id      :bigint           not null
#  name          :citext           not null
#  slug          :string           not null
#  description   :string
#  members_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_groups_on_name      (name) UNIQUE
#  index_groups_on_owner_id  (owner_id)
#  index_groups_on_slug      (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => pones.id)
#
class Group < ApplicationRecord
  include Sluggable

  NAME_MAX_LENGTH        = 50
  DESCRIPTION_MAX_LENGTH = 1000

  belongs_to :owner, class_name: 'Pone', inverse_of: :owned_groups

  has_unique_attribute :name
  has_unique_attribute :slug

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }

  generates_slug_from :name
end
