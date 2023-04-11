# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      binding.pry
      scope.all
    end
  end

  def index?
    @user.has_role? :admin
  end

  def edit?
    @user.has_role? :admin
  end

  def update?
    @user.has_role? :admin
  end

  def destroy?
    @user.has_role? :admin
  end

  def show?
    @user == @record
  end
end
