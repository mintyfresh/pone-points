# frozen_string_literal: true

class GroupListComponent < ApplicationComponent
  # @param groups [Array<Group>]
  # @param placeholder [String, nil]
  def initialize(groups:, placeholder: nil)
    @groups      = groups
    @placeholder = placeholder
  end
end
