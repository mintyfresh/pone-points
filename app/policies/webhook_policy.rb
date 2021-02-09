# frozen_string_literal: true

class WebhookPolicy < ApplicationPolicy
  alias webhook record

  def index?
    current_pone.present?
  end

  def show?
    current_pone.present? && current_pone == webhook.owner
  end

  def create?
    current_pone.present?
  end

  def regenerate?
    current_pone.present? && current_pone == webhook.owner
  end

  def destroy?
    current_pone.present? && current_pone == webhook.owner
  end

  class Scope < Scope
    def resolve
      return scope.none if current_pone.nil?

      scope.where(owner: current_pone)
    end
  end
end
