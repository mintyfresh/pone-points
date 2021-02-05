# frozen_string_literal: true

class BoonListComponent < ApplicationComponent
  # @param boons [Array<Boon>]
  def initialize(boons:)
    @boons = boons
  end
end
