# frozen_string_literal: true

module Roles
  BANNED    = 'banned'
  MODERATOR = 'moderator'
  RESQUE    = 'resque'

  def self.all
    @all ||= constants(false).map { |name| const_get(name) }.freeze
  end

  # @param role [String]
  # @return [Boolean]
  def self.supported?(role)
    all.include?(role)
  end
end
