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
      validate_uploaded_file(record, attribute, record.attachment_changes[attribute.to_s]&.attachable)
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
    return if value.nil?
    return unless validate_file_size(record, attribute, value)
    return unless validate_content_type(record, attribute, value)

    image = MiniMagick::Image.open(file_path(value))
    record.errors.add(attribute, :too_wide, maximum: MAXIMUM_WIDTH)  if image.width  > MAXIMUM_WIDTH
    record.errors.add(attribute, :too_tall, maximum: MAXIMUM_HEIGHT) if image.height > MAXIMUM_HEIGHT
  end

  # @return [Boolean]
  def validate_file_size(record, attribute, value)
    return true if file_size(value) <= MAXIMUM_FILE_SIZE

    record.errors.add(attribute, :too_large)

    false
  end

  # @return [Boolean]
  def validate_content_type(record, attribute, value)
    return true if SUPPORTED_TYPES.include?(content_type(value))

    record.errors.add(attribute, :unsupported)

    false
  end

  def file_size(value)
    case value
    when ActionDispatch::Http::UploadedFile
      value.size
    when Hash
      value[:io].size
    else
      raise TypeError, "Unsupported file type: `#{value.class.name}`"
    end
  end

  def content_type(value)
    case value
    when ActionDispatch::Http::UploadedFile
      value.content_type
    when Hash
      value[:content_type]
    else
      raise TypeError, "Unsupported file type: `#{value.class.name}`"
    end
  end

  def file_path(value)
    case value
    when ActionDispatch::Http::UploadedFile
      value.to_path
    when Hash
      value[:io]
    else
      raise TypeError, "Unsupported file type: `#{value.class.name}`"
    end
  end
end
