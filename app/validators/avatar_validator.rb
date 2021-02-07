# frozen_string_literal: true

class AvatarValidator < ActiveModel::EachValidator
  MAXIMUM_FILE_SIZE = 5.megabytes
  MAXIMUM_WIDTH     = 1000
  MAXIMUM_HEIGHT    = 1000
  SUPPORTED_TYPES   = %w[image/png image/jpeg image/jpg].freeze

  # @param record [ApplicationRecord, ApplicationForm]
  # @param attribute [Symbol]
  # @param value [ActiveStorage::Attached, ActionDispatch::Http::UploadedFile, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    case value
    when ActiveStorage::Attached
      validate_uploaded_file(record, attribute, record.attachment_changes[attribute.to_s].attachable)
    when ActionDispatch::Http::UploadedFile
      validate_uploaded_file(record, attribute, value)
    when nil
      # Nothing to do.
    else
      raise TypeError, "Unsupported avatar type: `#{value.class.name}`"
    end
  end

private

  def validate_uploaded_file(record, attribute, value)
    return unless validate_file_size(record, attribute, value)
    return unless validate_content_type(record, attribute, value)

    image = MiniMagick::Image.open(value.to_path)
    record.errors.add(attribute, :too_wide, maximum: MAXIMUM_WIDTH)  if image.width  > MAXIMUM_WIDTH
    record.errors.add(attribute, :too_tall, maximum: MAXIMUM_HEIGHT) if image.height > MAXIMUM_HEIGHT
  end

  # @return [Boolean]
  def validate_file_size(record, attribute, value)
    return true if value.size <= MAXIMUM_FILE_SIZE

    record.errors.add(attribute, :too_large)

    false
  end

  # @return [Boolean]
  def validate_content_type(record, attribute, value)
    return true if SUPPORTED_TYPES.include?(value.content_type)

    record.errors.add(attribute, :unsupported)

    false
  end
end
