# frozen_string_literal: true

class DisplayNameValidator < ActiveModel::EachValidator
  MINIMUM_LENGTH      = 3
  MAXIMUM_LENGTH      = 50
  DISPLAY_NAME_FORMAT = /\A[[:print:]]*\z/

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [String, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return blank!(record, attribute) if value.blank?

    too_short!(record, attribute) unless value.size >= MINIMUM_LENGTH
    too_long!(record, attribute)  unless value.size <= MAXIMUM_LENGTH
    malformed!(record, attribute) unless DISPLAY_NAME_FORMAT.match?(value)
  end

private

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  def blank!(record, attribute)
    record.errors.add(attribute, :blank) unless options[:allow_blank]
  end

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  def too_short!(record, attribute)
    record.errors.add(attribute, :too_short, count: MINIMUM_LENGTH)
  end

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  def too_long!(record, attribute)
    record.errors.add(attribute, :too_long, count: MAXIMUM_LENGTH)
  end

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  def malformed!(record, attribute)
    record.errors.add(attribute, options.fetch(:message, :display_name))
  end
end
