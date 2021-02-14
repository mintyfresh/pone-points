# frozen_string_literal: true

class RolesValidator < ActiveModel::EachValidator
  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [Array<String>, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank? || value.all? { |role| Roles.supported?(role) }

    record.errors.add(attribute, :unsupported_roles)
  end
end
