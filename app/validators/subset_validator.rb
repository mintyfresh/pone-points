# frozen_string_literal: true

class SubsetValidator < ActiveModel::EachValidator
  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [Array, Enumerable, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?

    supported = supported_values(record)
    return if value.all? { |element| element.in?(supported) }

    record.errors.add(attribute, :unsupported)
  end

private

  # @param record [Object]
  # @return [Array, Enumerable]
  def supported_values(record)
    case (value = options[:of])
    when Array, Enumerable
      value
    when Symbol
      record.send(value)
    when Proc
      record.instance_exec(&value)
    else
      raise TypeError, "Unsupported type for subset options: #{value.class.name}"
    end
  end
end
