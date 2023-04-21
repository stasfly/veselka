# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    @user.has_any_role? :admin
  end

  def edit?
    @user.has_any_role? :admin
  end

  def create?
    @user.has_any_role? :admin
  end
  
  def update?
    @user.has_any_role? :admin
  end

  def destroy?
    @user.has_any_role? :admin
  end
end
