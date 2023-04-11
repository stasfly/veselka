# frozen_string_literal: true

class CartItemPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    @record.cart.user == @user
  end

  def update?
    @record.cart.user == @user
  end

  def destroy?
    (@record.cart.user == @user) || (@user.has_any_role? :admin)
  end
end
