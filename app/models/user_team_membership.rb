class UserTeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :user_team

  validates :user_id, uniqueness: { scope: :user_team_id }
end
