# frozen_string_literal: true

class MessageRenderer < Redcarpet::Render::HTML
  # @param text [String]
  # @return [String]
  def paragraph(text)
    %(<p class="mb-0">#{text}</p>)
  end
end
