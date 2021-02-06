# frozen_string_literal: true

module NavLink
  # @param label [String]
  # @param link [String, Object]
  # @param options [Hash]
  # @return [String]
  def nav_link(label, link, **options)
    render(NavLinkComponent.new(label: label, link: link, **options))
  end
end
