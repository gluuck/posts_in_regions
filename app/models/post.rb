class Post < ApplicationRecord
  include AASM
  belongs_to :region
  belongs_to :user
  has_many_attached :images
  has_many_attached :files

  validates :title, :body, :region_id, :user_id, presence: true

  def author?(current_user)
    user == current_user
  end

  aasm do
    state :draft, initial: true
    state :under_review
    state :approved
    state :rejected

    event :to_review do
      transitions from: :draft, to: :under_review
    end
    event :to_approve do
      transitions from: %i[draft under_review approved], to: :approved
    end
    event :to_reject do
      transitions from: %i[draft under_review approved], to: :rejected
    end
  end
end
