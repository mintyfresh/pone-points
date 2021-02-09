# frozen_string_literal: true

class TypeValidator < ActiveModel::EachValidator
  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [Object, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.nil? || value.is_a?(expected_type(record))

    record.errors.add(attribute, :incorrect_type)
  end

private

  # @param record [Object]
  # @return [Class]
  def expected_type(record)
    case (value = options[:name])
    when Class, String
      value.to_s.safe_constantize
    when Symbol
      record.send(value)
    when Proc
      record.instance_exec(&value)
    else
      raise TypeError, "Unsupported type for type options: #{value.class.name}"
    end
  end
end
