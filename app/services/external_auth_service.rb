# frozen_string_literal: true

class ExternalAuthService
  CREDENTIAL_CLASS_MAPPINGS = {
    'discord' => 'PoneDiscordCredential',
    'github'  => 'PoneGithubCredential'
  }.freeze

  TOKEN_ENCRYPTOR = ActiveSupport::MessageEncryptor.new(ENV['EXTERNAL_AUTH_KEY'])

  # @param external_auth_hash [Hash]
  # @param current_pone [Pone]
  # @return [Pone]
  def link_account(external_auth_hash, pone)
    pone.credential(external_credential_class(external_auth_hash[:provider]), build_if_missing: true)
      .update!(external_id: external_auth_hash[:uid]) && pone
  end

  # @param external_auth_hash [Hash]
  # @return [Pone, nil]
  def sign_in(external_auth_hash)
    Pone.find_by_external_id(
      external_credential_class(external_auth_hash[:provider]),
      external_auth_hash[:uid]
    )
  end

  # @param external_auth_hash [Hash]
  # @return [String]
  def generate_sign_up_token(external_auth_hash)
    TOKEN_ENCRYPTOR.encrypt_and_sign(
      {
        account_name: external_auth_hash.dig(:info, :name),
        provider:     external_auth_hash[:provider],
        external_id:  external_auth_hash[:uid]
      }.to_json,
      expires_in: 1.hour,
      purpose:    :sign_up
    )
  end

  # @param sign_up_token [String]
  # @return [Hash<Symbol => String>]
  def parse_sign_up_token(sign_up_token)
    return {} if sign_up_token.blank?

    JSON.parse(TOKEN_ENCRYPTOR.decrypt_and_verify(sign_up_token, purpose: :sign_up)).symbolize_keys
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, JSON::ParserError
    {}
  end

  # @param token [String]
  # @param attributes [Hash]
  # @return [Pone]
  def sign_up(sign_up_token, attributes)
    payload = parse_sign_up_token(sign_up_token)

    Pone.create!(attributes) do |pone|
      pone.credentials << external_credential_class(payload[:provider]).new(external_id: payload[:external_id])
    end
  end

private

  # @param provider [String]
  # @return [Class<PoneCredential>]
  def external_credential_class(provider)
    class_name = CREDENTIAL_CLASS_MAPPINGS.fetch(provider) do
      raise ArgumentError, "Unsupported OAuth provider: #{provider}"
    end

    class_name.safe_constantize
  end
end
