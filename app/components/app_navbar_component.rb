# frozen_string_literal: true

class AppNavbarComponent < ApplicationComponent
  # @param current_pone [Pone, nil]
  def initialize(current_pone:)
    @current_pone = current_pone
  end

  # @param label [String]
  # @param link [String, Object]
  # @param options [Hash]
  # @return [String]
  def nav_link(label, link, **options)
    render(NavLinkComponent.new(label: label, link: link, **options))
  end
end
