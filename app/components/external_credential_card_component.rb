# frozen_string_literal: true

class ExternalCredentialCardComponent < ApplicationComponent
  # @param icon [String]
  # @param name [String]
  # @param credential_class [Class<PoneCredential>]
  # @parma current_pone [Pone, nil]
  def initialize(icon:, name:, credential_class:, current_pone:)
    @icon             = icon
    @name             = name
    @credential_class = credential_class
    @current_pone     = current_pone
  end

  # @return [PoneCredential]
  def credential
    return @credential if defined?(@credential)

    @credential = @current_pone&.credential(@credential_class)
  end
end
