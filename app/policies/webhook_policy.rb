# frozen_string_literal: true

class WebhookPolicy < ApplicationPolicy
  alias webhook record

  def index?
    current_pone.present?
  end

  def show?
    current_pone.present? && current_pone == webhook.pone
  end

  def create?
    current_pone.present?
  end

  def regenerate?
    current_pone.present? && current_pone == webhook.pone
  end

  def destroy?
    current_pone.present? && current_pone == webhook.pone
  end

  class Scope < Scope
    def resolve
      return scope.none if current_pone.nil?

      scope.where(pone: current_pone)
    end
  end
end
