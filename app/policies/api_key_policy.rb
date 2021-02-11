# frozen_string_literal: true

class ApiKeyPolicy < ApplicationPolicy
  alias api_key record

  def index?
    current_pone.present?
  end

  def show?
    current_pone.present? && current_pone == api_key.pone
  end

  def create?
    current_pone.present?
  end

  def regenerate?
    current_pone.present? && current_pone == api_key.pone
  end

  def revoke?
    current_pone.present? && current_pone == api_key.pone
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
end
