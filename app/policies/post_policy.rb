class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.region == user.region || user.admin?
  end

  def edit?
    user.present? && (record.aasm_state == 'draft' || record.author?(user) || user.admin?)
  end

  def update?
    user.present? && (record.aasm_state == 'draft' || record.aasm_state == 'under_review' || record.aasm_state == 'approved' || record.author?(user) || user.admin?)
  end

  def change_state?
    user.admin?
  end

  def approve?
    user.admin?
  end

  def reject?
    user.admin?
  end

  def review?
    user.admin?
  end
end
