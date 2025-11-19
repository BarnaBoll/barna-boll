class UserTeamMembership < ApplicationRecord
  belongs_to :user
  belongs_to :user_team

  validates :user_id, uniqueness: { scope: :user_team_id }

  after_commit :send_member_added_email, on: :create

  private

  def send_member_added_email
    # Don’t email the creator when they’re auto-added to their own team
    return if user_id == user_team.creator_id

    TeamMailer.member_added(id).deliver_later
  end
end
