# frozen_string_literal: true

class PointPolicy < ApplicationPolicy
  alias point record

  def index?
    true
  end

  def show?
    !point.deleted?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
