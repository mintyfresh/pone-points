# frozen_string_literal: true

class PoneProfileNavComponent < ApplicationComponent
  # @param pone [Pone]
  def initialize(pone:)
    @pone = pone
  end

  # @param label [String]
  # @param mode [String]
  # @return [String]
  def nav_link(label, mode:)
    render(NavLinkComponent.new(label: label, link: pone_path(@pone, mode: mode)))
  end
end
