# frozen_string_literal: true

module RoleAuthorizable
  extend ActiveSupport::Concern

  included do
    validates :roles, roles: true

    before_save :remove_duplicate_roles, if: :roles_changed?
  end

  # @param role [String]
  # @return [Boolean]
  def add_role(role)
    roles.push(role) && true
  end

  # @param role [String]
  # @return [Boolean]
  def add_role!(role)
    add_role(role) && save!
  end

  # @param role [String]
  # @return [Boolean]
  def role?(role)
    roles.include?(role)
  end

  # @param role [String]
  # @return [Boolean]
  def remove_role(role)
    roles.delete(role) && true
  end

  # @param role [String]
  # @return [Boolean]
  def remove_role!(role)
    remove_role(role) && save!
  end

private

  # @return [void]
  def remove_duplicate_roles
    self.roles = roles.uniq.sort
  end
end
