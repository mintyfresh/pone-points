# frozen_string_literal: true

class FormBaseErrorsComponent < ApplicationComponent
  # @param errors [ActiveModel::Errors]
  def initialize(errors:)
    @errors = errors
  end
end
