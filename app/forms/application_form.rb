# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def self.new(*args, **options)
    super.tap do |form|
      yield(form) if block_given?
    end
  end

  def perform(&block)
    return false if invalid?

    result = catch(:abort, &block)
    return false if errors.any?

    result
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, ActiveRecord::RecordNotDestroyed => error
    copy_errors(error.record.errors)

    false
  end

protected

  # @param errors [ActiveModel::Errors]
  # @param prefix [String, nil]
  # @return [void]
  def copy_errors(errors, prefix: nil)
    errors.each do |error|
      attribute = error.attribute
      attribute = "#{prefix}.#{attribute}" if prefix
      message   = error.message

      self.errors.add(attribute, message)
    end
  end

  def transaction(**options, &block)
    ApplicationRecord.transaction(**options, &block)
  end
end
