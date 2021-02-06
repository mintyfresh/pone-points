# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id                          :bigint           not null, primary key
#  name                        :citext           not null
#  slug                        :string           not null
#  points_count                :integer          default(0), not null
#  daily_giftable_points_count :integer          default(0), not null
#  verified_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
class Pone < ApplicationRecord
  include Sluggable
  include Verifyable

  has_many :credentials, class_name: 'PoneCredential', dependent: :destroy, inverse_of: :pone

  has_many :points, dependent: :destroy, inverse_of: :pone
  has_many :granted_points, class_name: 'Point', dependent: :restrict_with_error,
                            foreign_key: :granted_by_id, inverse_of: :granted_by

  has_many :unlocked_achievements, dependent: :destroy, inverse_of: :pone
  has_many :achievements, through: :unlocked_achievements

  has_unique_attribute :name
  has_unique_attribute :slug

  validates :name, presence: true, length: { maximum: 50 }
  validates :daily_giftable_points_count, numericality: { greater_than_or_equal_to: 0 }

  generates_slug_from :name

  before_verify :set_daily_giftable_points_count

  after_verify :add_point_from_system_pone

  # @parma credential_class [Class<PoneCredential>]
  # @param external_id [String]
  # @return [Pone]
  def self.find_or_create_pone_by_external_id!(credential_class, external_id)
    credential_class.find_by(external_id: external_id)&.pone || Pone.create! do |pone|
      pone.credentials << credential_class.new(external_id: external_id)
      yield(pone)
    end
  end

  # @param credential_class [Class<PoneCredential>]
  # @param credential [Object]
  # @return [self, nil]
  def authenticate(credential_class, credential)
    credential(credential_class)&.authenticate(credential)
  end

  # @param credential_class [Class<PoneCredential>]
  # @param build_if_missing [Boolean]
  # @return [PoneCredential, nil]
  def credential(credential_class, build_if_missing: false)
    credential = credentials.find_by(type: credential_class.sti_name)
    return credential if credential || !build_if_missing

    credentials.build(type: credential_class.sti_name)
  end

  # @return [Integer]
  def giftable_points_count
    daily_giftable_points_count - granted_points.today.sum(:count)
  end

  # @param achievement [Achievement]
  # @return [Boolean]
  def achievement_unlocked?(achievement)
    achievements.include?(achievement)
  end

  # @param achievement [Achievement]
  # @return [Boolean]
  def unlock_achievement(achievement)
    unlocked_achievements.create_or_find_by!(achievement: achievement) && true
  end

private

  # @return [void]
  def set_daily_giftable_points_count
    self.daily_giftable_points_count = 3
  end

  # TODO: Remove me. Use pub/sub instead.
  # @return [void]
  def add_point_from_system_pone
    points.find_or_create_by!(
      granted_by: Pone.find_by!(name: 'System Pone'),
      count:      1,
      message:    'For being a good, verified pone, of course!'
    )
  end
end
