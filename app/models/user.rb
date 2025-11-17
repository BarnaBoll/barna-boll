class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  validates :name, presence: true, length: { maximum: 100 }

  scope :admins, -> { where(admin: true) }

  def name_or_email
    name.presence || email
  end
end
