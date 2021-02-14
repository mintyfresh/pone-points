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
#  bonus_points_count          :integer          default(0), not null
#  giftable_points_count       :integer          default(0), not null
#  roles                       :string           default([]), not null, is an Array
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
class Pone < ApplicationRecord
  DEFAULT_DAILY_GIFTABLE_POINTS_COUNT = 3

  include RoleAuthorizable
  include Sluggable
  include Verifyable
  include Webhookable

  has_one_attached :avatar

  has_many :api_keys, dependent: :destroy, inverse_of: :pone
  has_many :credentials, class_name: 'PoneCredential', dependent: :destroy, inverse_of: :pone
  has_many :owned_webhooks, class_name: 'Webhook', dependent: :destroy, foreign_key: :owner_id, inverse_of: :owner

  has_many :bans, dependent: :destroy, inverse_of: :pone
  has_many :issued_bans, class_name: 'Ban', dependent: :restrict_with_error,
                         foreign_key: :issuer_id, inverse_of: :issuer

  has_many :owned_groups, class_name: 'Group', dependent: :restrict_with_error,
                          foreign_key: :owner_id, inverse_of: :owner

  has_many :memberships, dependent: :destroy, foreign_key: :member_id, inverse_of: :member
  has_many :groups, through: :memberships

  has_many :points, dependent: :destroy, inverse_of: :pone
  has_many :granted_points, class_name: 'Point', dependent: :restrict_with_error,
                            foreign_key: :granted_by_id, inverse_of: :granted_by

  has_many :unlocked_achievements, dependent: :destroy, inverse_of: :pone
  has_many :achievements, through: :unlocked_achievements

  has_unique_attribute :name
  has_unique_attribute :slug

  validates :name, presence: true, length: { maximum: 50 }
  validates :giftable_points_count, :daily_giftable_points_count, :bonus_points_count,
            numericality: { greater_than_or_equal_to: 0 }
  validates :avatar, content_type: %i[jpg jpeg png], size: { less_than: 5.megabytes },
                     dimension: { width: { max: 1000 }, height: { max: 1000 } }

  generates_slug_from :name

  before_save :set_avatar_file_name, if: -> { attachment_changes['avatar'].present? }

  before_verify :set_daily_giftable_points_count

  # @parma credential_class [Class<PoneCredential>]
  # @param external_id [String]
  # @return [Pone, nil]
  def self.find_by_external_id(credential_class, external_id)
    credential_class.find_by(external_id: external_id)&.pone
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

  # Giftable points, including both daily and bonus points.
  #
  # @return [Integer]
  def total_giftable_points_count
    giftable_points_count + bonus_points_count
  end

  # @param count [Integer]
  # @return [Boolean]
  def spend_points(count)
    with_lock do
      if giftable_points_count >= count
        update!(giftable_points_count: giftable_points_count - count)
      elsif total_giftable_points_count >= count
        update!(giftable_points_count: 0, bonus_points_count: bonus_points_count - (count - giftable_points_count))
      else
        false
      end
    end
  end

private

  # @return [void]
  def set_daily_giftable_points_count
    self.giftable_points_count       = DEFAULT_DAILY_GIFTABLE_POINTS_COUNT
    self.daily_giftable_points_count = DEFAULT_DAILY_GIFTABLE_POINTS_COUNT
  end

  # @return [void]
  def set_avatar_file_name
    avatar          = attachment_changes['avatar'].attachment
    avatar.filename = "#{slug}.#{avatar.filename.extension}"
  end
end
