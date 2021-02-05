# frozen_string_literal: true

class PoneProfileComponent < ApplicationComponent
  # @param pone [Pone]
  def initialize(pone:)
    @pone = pone
  end
end
