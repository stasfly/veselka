# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    (@user == @record.user) || (@user.has_any_role? :admin)
  end
end
