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
  define_model_callbacks :verify

  has_many :credentials, class_name: 'PoneCredential', dependent: :destroy, inverse_of: :pone

  has_many :boons, -> { order(created_at: :desc, id: :desc) }, dependent: :destroy, inverse_of: :pone
  has_many :granted_boons, class_name: 'Boon', dependent: :restrict_with_error,
                           foreign_key: :granted_by_id, inverse_of: :granted_by

  has_unique_attribute :name
  has_unique_attribute :slug

  validates :name, presence: true, length: { maximum: 50 }
  validates :daily_giftable_points_count, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_slug_from_name, if: :name_changed?

  after_verify :add_boon_from_system_pone

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
    return credential if credential || build_if_missing

    credentials.build(type: credential_class.sti_name)
  end

  # @return [Integer]
  def giftable_points_count
    daily_giftable_points_count - granted_boons.today.sum(:points_count)
  end

  # @return [String, nil]
  def to_param
    slug
  end

  # @return [Boolean]
  def verified?
    verified_at.present?
  end

  # @return [Boolean]
  def verified!
    with_lock do
      return true if verified?

      run_callbacks(:verify) do
        update!(
          daily_giftable_points_count: 3,
          verified_at:                 Time.current
        )
      end
    end
  end

private

  # @return [void]
  def set_slug_from_name
    self.slug = name.parameterize
  end

  # TODO: Remove me. Use pub/sub instead.
  # @return [void]
  def add_boon_from_system_pone
    boons.find_or_create_by!(
      granted_by:   Pone.find_by!(name: 'System Pone'),
      points_count: 1,
      reason:       'For being a good, verified pone, of course!'
    )
  end
end
