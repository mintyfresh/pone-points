# frozen_string_literal: true

class PonePolicy < ApplicationPolicy
  alias pone record

  def show?
    true
  end

  def give_points?
    show? && current_pone.present?
  end
end
