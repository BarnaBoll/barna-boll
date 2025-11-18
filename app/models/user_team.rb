class UserTeam < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :user_team_memberships, dependent: :destroy
  has_many :members, through: :user_team_memberships, source: :user

  validates :name, presence: true, length: { maximum: 100 }

  def creator?(user)
    user.present? && creator_id == user.id
  end

  def includes?(user)
    return false unless user
    members.exists?(user.id)
  end
end
