# frozen_string_literal: true

module Verifyable
  extend ActiveSupport::Concern

  included do
    define_model_callbacks :verify

    scope :verified,   -> { where.not(verified_at: nil) }
    scope :unverified, -> { where(verified_at: nil)     }

    after_commit :publish_record_verified, if: :saved_change_to_verified_at?
  end

  # @return [Boolean]
  def verified_before_last_save?
    verified_at_before_last_save.present?
  end

  # @return [Boolean]
  def verified?
    verified_at.present?
  end

  # @return [Boolean]
  def unverified?
    verified_at.blank?
  end

  # @return [Boolean]
  def verified!
    with_lock do
      return true if verified?

      run_callbacks(:verify) do
        update!(verified_at: Time.current)
      end
    end
  end

private

  # @return [void]
  def publish_record_verified
    publish(:verify) if verified? && !verified_before_last_save?
  end
end
