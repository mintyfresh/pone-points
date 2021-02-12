# frozen_string_literal: true

class RedirectController < ApplicationController
  before_action :set_destination_url

  def confirm
    redirect_to(@destination_url.to_s) if same_site?(@destination_url)
  end

private

  def set_destination_url
    @destination_url = parse_uri(params[:url])
    @destination_url = parse_uri("https://#{params[:url]}") if @destination_url.scheme.nil?
    return if @destination_url.is_a?(URI::HTTP) && @destination_url.host.present?

    # Invalid or non-HTTP URL, take the user back.
    redirect_back(fallback_location: root_path)
  end

  # @param uri [String, nil]
  # @return [URI, nil]
  def parse_uri(uri)
    URI(uri) if uri.present?
  rescue URI::InvalidURIError
    nil
  end

  # @param uri [URI]
  # @return [Boolean]
  def same_site?(uri)
    host = request.env['HTTP_HOST']
    return false if host.blank?

    name, port = host.split(':', 2)
    return false if name.blank?

    port = default_port_for_uri_scheme(uri) if port.nil?
    port = port.to_i

    uri.host == name && uri.port == port
  end

  # @param uri [URI]
  # @return [Integer]
  def default_port_for_uri_scheme(uri)
    case uri
    when URI::HTTP
      uri.scheme == 'https' ? 443 : 80
    else
      80
    end
  end
end
