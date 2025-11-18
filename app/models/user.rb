class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  validates :name, presence: true, length: { maximum: 100 }

  scope :admins, -> { where(admin: true) }

  # Teams the user has created (as “owner”)
  has_many :user_teams_created,
           class_name: "UserTeam",
           foreign_key: :creator_id,
           dependent: :nullify

  # Teams the user is a member of
  has_many :user_team_memberships, dependent: :destroy
  has_many :user_teams, through: :user_team_memberships, source: :user_team

  # Registrations (for upcoming matches)
  has_many :registrations, dependent: :nullify
  has_many :registered_teams, through: :registrations, source: :team
  has_many :registered_matches, through: :registered_teams, source: :match

  def name_or_email
    name.presence || email
  end
end
