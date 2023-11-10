# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.has_any_role? :admin
        scope.all
      else
        return scope.none if @user.has_any_role? :inactive

        scope.where(user_id: @user.id)
      end
    end
  end

  def index?
    true
  end

  def show?
    (@user.id == @record.user_id) || (@user.has_any_role? :admin)
  end

  def create?
    @user == @record.user
  end
end
