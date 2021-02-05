# frozen_string_literal: true

class PoneProfileComponent < ApplicationComponent
  # @param pone [Pone]
  # @param current_pone [Pone, nil]
  def initialize(pone:, current_pone:)
    @pone         = pone
    @current_pone = current_pone
  end
end
