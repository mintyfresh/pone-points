# frozen_string_literal: true

class WebhookPolicy < ApplicationPolicy
  alias webhook record

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

  def destroy?
    owner?
  end

  def permitted_attributes_for_create
    [:name, :url, :events, { events: [] }]
  end

  class Scope < Scope
    def resolve
      return scope.none if current_pone.nil?

      scope.where(owner: current_pone)
    end
  end

private

  # @return [Boolean]
  def banned?
    current_pone.present? && current_pone.banned?
  end

  # @return [Boolean]
  def owner?
    current_pone.present? && current_pone == webhook.owner
  end
end
