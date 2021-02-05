# frozen_string_literal: true

module ApplicationHelper
  def title
    return content_for(:title) if content_for?(:title)

    t("#{controller_path.tr('/', '.')}.#{action_name}.title", default: 'Good Pone Points')
  end
end
