# frozen_string_literal: true

class AppNavbarComponent < ApplicationComponent
  include NavLink

  # @param current_pone [Pone, nil]
  def initialize(current_pone:)
    @current_pone = current_pone
  end
end
