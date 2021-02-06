# frozen_string_literal: true

module HasGeneratedToken
  DEFAULT_TOKEN_LENGTH   = 80
  TOKEN_DIGEST_ALGORITHM = Arel::Nodes::Quoted.new('sha256').freeze
  TOKEN_DIGEST_ENCODING  = Arel::Nodes::Quoted.new('hex').freeze

  # @param column [Symbol, String]
  # @return [Arel::Nodes::Node]
  def arel_digest(column)
    Arel::Nodes::NamedFunction.new('digest', [arel_table[column], TOKEN_DIGEST_ALGORITHM]).freeze
  end

  # @param column [Symbol, String]
  # @return [Arel::Nodes::Node]
  def arel_hexdigest(column)
    Arel::Nodes::NamedFunction.new('encode', [arel_digest(column), TOKEN_DIGEST_ENCODING]).freeze
  end

  # @param field [Symbol, String]
  # @param length [Integer]
  # @return [void]
  def has_generated_token(field, length: DEFAULT_TOKEN_LENGTH) # rubocop:disable Naming/PredicateName
    after_initialize(if: :new_record?) { send("#{field}=", SecureRandom.base58(length)) }
    define_method(:"regenerate_#{field}") { update!(field => SecureRandom.base58(length)) }
  end

  # @param field [Symbol, String]
  # @param value [String, nil]
  # @return [void]
  def find_by_hexdigest(field, value)
    return if value.blank?

    hexdigest = Digest::SHA256.hexdigest(value)

    where(arel_hexdigest(field).eq(hexdigest))
      .find { |record| record.send(field) == value }
  end
end
