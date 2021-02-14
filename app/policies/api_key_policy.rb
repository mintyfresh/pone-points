# frozen_string_literal: true

class ApiKeyPolicy < ApplicationPolicy
  alias api_key record

  def index?
    current_pone.present?
  end

  def show?
    owner?
  end

  def create?
    current_pone.present? && !banned?
  end

  def regenerate?
    owner?
  end

  def revoke?
    owner?
  end

  # @return [Array]
  def permitted_attributes_for_create
    %i[name description]
  end

  class Scope < Scope
    def resolve
      return scope.none if current_pone.nil?

      scope.where(pone: current_pone)
    end
  end

private

  # @return [Boolean]
  def banned?
    current_pone.present? && current_pone.role?(Roles::BANNED)
  end

  # @return [Boolean]
  def owner?
    current_pone.present? && current_pone == api_key.pone
  end
end
