# frozen_string_literal: true

class PonePolicy < ApplicationPolicy
  alias pone record

  def index?
    true
  end

  def show?
    true
  end

  def give_points?
    show? && current_pone.present? && current_pone != pone
  end

  def integrations?
    current_pone.present? && current_pone == pone
  end

  def change_password?
    current_pone.present? && current_pone == pone
  end

  def update?
    current_pone.present? && current_pone == pone
  end
end
