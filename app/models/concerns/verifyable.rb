# frozen_string_literal: true

module Verifyable
  extend ActiveSupport::Concern

  included do
    define_model_callbacks :verify

    scope :verified,   -> { where.not(verified_at: nil) }
    scope :unverified, -> { where(verified_at: nil)     }
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
        update!(verified_at: Time.current)
      end
    end
  end
end
