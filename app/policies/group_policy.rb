# frozen_string_literal: true

class GroupPolicy < ApplicationPolicy
  alias group record

  def index?
    true
  end

  def show?
    true
  end

  def create?
    current_pone.present?
  end

  def join?
    current_pone.present?
  end

  alias leave? join?
end
