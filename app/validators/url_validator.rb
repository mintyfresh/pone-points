# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [String, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI(value)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    record.errors.add(attribute, :invalid_url)
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid_url)
  end
end

