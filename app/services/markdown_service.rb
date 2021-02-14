# frozen_string_literal: true

class MarkdownService
  MARKDOWN_OPTIONS = {
    autolink:                     true,
    disable_indented_code_blocks: true,
    lax_spacing:                  true,
    no_intra_emphasis:            true,
    strikethrough:                true,
    underline:                    true
  }.freeze

  MARKDOWN_RENDERER_OPTIONS = {
    escape_html:     true,
    safe_links_only: true
  }.freeze

  def initialize
    @markdown = Redcarpet::Markdown.new(MessageRenderer.new(MARKDOWN_RENDERER_OPTIONS), MARKDOWN_OPTIONS)
  end

  # @param message [String]
  # @return [String]
  def render(message)
    @markdown.render(message)
  end
end
