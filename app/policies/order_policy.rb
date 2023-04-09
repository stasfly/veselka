# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    (@user.id == @record.sample.user_id) || (@user.has_any_role? :admin)
  end

  def show?
    (@user.id == @record.user_id) || (@user.has_any_role? :admin)
  end

  def create?
    @user == @record.user
  end
end
