# frozen_string_literal: true

class GroupControlsDropdownComponent < ApplicationComponent
  # @param group [Group]
  # @param current_pone [Pone, nil]
  def initialize(group:, current_pone:)
    @group        = group
    @current_pone = current_pone
  end

  # @return [Boolean]
  def owner?
    @current_pone == @group.owner
  end
end
