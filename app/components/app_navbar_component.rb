# frozen_string_literal: true

class AppNavbarComponent < ApplicationComponent
  # @param current_pone [Pone, nil]
  def initialize(current_pone:)
    @current_pone = current_pone
  end
end
