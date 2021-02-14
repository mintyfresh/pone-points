# frozen_string_literal: true

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deleted_by, class_name: 'Pone', inverse_of: false, optional: true

    default_scope -> { where(deleted_at: nil) }

    after_commit :publish_record_deleted, if: -> { saved_change_to_deleted?(to: true) }
  end

  class_methods do
    def before_delete(*args, **options, &block)
      before_save(*args, **options, if: [-> { deleted_changed?(to: true) }, *options[:if]], &block)
    end

    def after_delete(*args, **options, &block)
      after_save(*args, **options, if: [-> { saved_change_to_deleted?(to: true) }, *options[:if]], &block)
    end
  end

  # @return [void]
  def delete
    update_columns(deleted_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end

  # @return [Boolean]
  def deleted?
    deleted_at.present?
  end

  # @param value [String, Boolean]
  # @return [void]
  def deleted=(value)
    self.deleted_at = ActiveRecord::Type::Boolean.new.cast(value) ? Time.current : nil
  end

  # @param to [Boolean]
  # @param from [Boolean]
  # @return [void]
  def deleted_changed?(to: :_, from: :_)
    return false unless deleted_at_changed?
    return false if to   != :_ && to   != deleted_at.present?
    return false if from != :_ && from != deleted_at_was.present?

    true
  end

  # @param to [Boolean]
  # @param from [Boolean]
  # @return [void]
  def saved_change_to_deleted?(to: :_, from: :_)
    return false unless saved_change_to_deleted_at?
    return false if to   != :_ && to   != deleted_at.present?
    return false if from != :_ && from != deleted_at_before_last_save.present?

    true
  end

  # @param deleted_by [Pone, nil]
  # @return [Boolean]
  def destroy(deleted_by: nil)
    update(deleted_at: Time.current, deleted_by: deleted_by)
  end

  # @param deleted_by [Pone, nil]
  # @return [Boolean]
  def destroy!(deleted_by: nil)
    update!(deleted_at: Time.current, deleted_by: deleted_by)
  end

  # @return [void]
  def mark_for_destruction
    self.deleted_at = Time.current
  end

  # @return [Boolean]
  def marked_for_destruction?
    deleted_at.present? && deleted_at_changed?
  end

private

  # @return [void]
  def publish_record_deleted
    publish(:delete, deleted_by: deleted_by)
  end
end
