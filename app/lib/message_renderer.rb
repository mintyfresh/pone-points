# frozen_string_literal: true

class MessageRenderer < Redcarpet::Render::HTML
  class Helpers
    include Singleton
    include Rails.application.routes.url_helpers

    delegate :link_to, :mail_to, to: 'ApplicationController.helpers'
  end

  # @param text [String]
  # @return [String]
  def paragraph(text)
    %(<p class="mb-0">#{text}</p>)
  end

  # @param link [String]
  # @param link_type [:url, :email]
  # @return [String]
  def autolink(link, linktype)
    case linktype
    when :url
      helpers.link_to(link, helpers.redirect_confirm_path(url: link))
    when :email
      helpers.mail_to(link, link)
    end
  end

  # @param link [String]
  # @param content [String]
  # @return [String]
  def link(link, _title, content)
    helpers.link_to(content, helpers.redirect_confirm_path(url: link))
  end

private

  # @return [Helpers]
  def helpers
    Helpers.instance
  end
end
