# frozen_string_literal: true

class BanPolicy < ApplicationPolicy
  alias ban record

  def index?
    current_pone.present?
  end

  class Scope < Scope
    def resolve
      return scope.none if current_pone.nil?

      scope.where(pone: current_pone)
    end
  end
end
