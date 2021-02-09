# frozen_string_literal: true

class SubsetValidator < ActiveModel::EachValidator
  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [Array, Enumerable, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value.all? { |element| element.in?(options[:of]) }

    record.errors.add(attribute, :unsupported)
  end
end
