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
  include Webhookable

  NAME_MAX_LENGTH        = 50
  DESCRIPTION_MAX_LENGTH = 1000

  belongs_to :owner, class_name: 'Pone', inverse_of: :owned_groups

  has_many :memberships, dependent: :destroy, inverse_of: :group
  has_many :members, through: :memberships

  has_unique_attribute :name
  has_unique_attribute :slug

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }

  generates_slug_from :name

  after_create :add_owner_as_group_member

  # @param member [Pone]
  # @return [Membership]
  def add_member(member)
    memberships.find_or_create_by!(member: member)
  end

  # @param member [Pone]
  # @return [Boolean]
  def member?(member)
    memberships.exists?(member: member)
  end

  # @param member [Pone]
  # @return [Membership, nil]
  def remove_member(member)
    memberships.find_by(member: member)&.destroy!
  end

private

  # @return [void]
  def add_owner_as_group_member
    add_member(owner)
  end
end
