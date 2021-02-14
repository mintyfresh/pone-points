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
    return false unless show?
    return false if current_pone.nil? || banned?

    current_pone.verified? && current_pone != pone
  end

  def integrations?
    self?
  end

  def change_password?
    self?
  end

  def update?
    self? && !banned?
  end

private

  # @return [Boolean]
  def banned?
    current_pone.present? && current_pone.banned?
  end

  def self?
    current_pone.present? && current_pone == pone
  end
end
