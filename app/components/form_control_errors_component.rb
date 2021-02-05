# frozen_string_literal: true

class FormControlErrorsComponent < ApplicationComponent
  # @param key [String]
  # @param errors [ActiveModel::Errors]
  def initialize(key:, errors:)
    @key    = key
    @errors = errors
  end
end
