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
    current_pone.present? && !banned?
  end

  def join?
    current_pone.present? && !banned?
  end

  alias leave? join?

  def update?
    owner? && !banned?
  end

  def permitted_attributes_for_update
    %i[description]
  end

  def permitted_attributes_for_update_image
    %i[image]
  end

private

  # @return [Boolean]
  def banned?
    current_pone.present? && current_pone.banned?
  end

  # @return [Boolean]
  def owner?
    current_pone.present? && current_pone == group.owner
  end
end
