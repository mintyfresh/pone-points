# frozen_string_literal: true

class GroupListComponent < ApplicationComponent
  # @param groups [Array<Group>]
  def initialize(groups:)
    @groups = groups
  end
end
