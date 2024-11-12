class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  belongs_to :region

  validates :first_name, :last_name, :region_id, presence: true, unless: -> { admin? }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum role: { user: 0, admin: 1 }

  def admin?
    role == 'admin'
  end
end
