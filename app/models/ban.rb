# frozen_string_literal: true

# == Schema Information
#
# Table name: bans
#
#  id         :bigint           not null, primary key
#  pone_id    :bigint           not null
#  issuer_id  :bigint           not null
#  reason     :string           not null
#  expires_at :datetime
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bans_on_issuer_id  (issuer_id)
#  index_bans_on_pone_id    (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (issuer_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
class Ban < ApplicationRecord
  REASON_MAX_LENGTH = 1000

  define_model_callbacks :revoke

  belongs_to :pone, inverse_of: :bans
  belongs_to :issuer, class_name: 'Pone', inverse_of: :issued_bans

  validates :reason, presence: true, length: { maximum: REASON_MAX_LENGTH }

  after_create :mark_pone_as_banned
  after_revoke :mark_pone_as_unbanned

  after_commit :publish_ban_revoked, if: :saved_change_to_revoked_at?

  scope :active,  -> { where(revoked_at: nil) }
  scope :expired, -> { where(expires_at: ...Time.current) }

  # @return [Boolean]
  def active?
    revoked_at.nil?
  end

  # @return [Boolean]
  def expired?
    expires_at ? expires_at.past? : false
  end

  # @return [Boolean]
  def permanent?
    expires_at.nil?
  end

  # @return [Boolean]
  def revoked?
    revoked_at.present?
  end

  # @return [Boolean]
  def revoked!
    with_lock do
      return true if revoked?

      run_callbacks(:revoke) do
        update!(revoked_at: Time.current)
      end
    end
  end

private

  # @return [void]
  def mark_pone_as_banned
    pone.add_role!(Roles::BANNED) if active?
  end

  # @return [void]
  def mark_pone_as_unbanned
    pone.with_lock do
      pone.remove_role!(Roles::BANNED) if pone.bans.active.none?
    end
  end

  # @return [void]
  def publish_ban_revoked
    publish(:revoke) if revoked? && revoked_at_before_last_save.nil?
  end
end
