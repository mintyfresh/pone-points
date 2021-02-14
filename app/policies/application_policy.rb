# frozen_string_literal: true

class ApplicationPolicy
  # @return [Pone, nil]
  attr_reader :current_pone
  # @return [Class, Object]
  attr_reader :record

  # @param current_pone [Pone, nil]
  # @param record [Class, Object]
  def initialize(current_pone, record)
    @current_pone = current_pone
    @record       = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    # @return [Pone, nil]
    attr_reader :current_pone
    # @return [Class, Object]
    attr_reader :scope

    # @param current_pone [Pone, nil]
    # @param scope [ActiveRecord::Relation]
    def initialize(current_pone, scope)
      @current_pone = current_pone
      @scope        = scope
    end

    def resolve
      scope.all
    end
  end

protected

  # @param name [String]
  # @return [Boolean]
  def role?(name)
    current_pone.present? && current_pone.role?(name)
  end
end
