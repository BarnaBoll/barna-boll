class Registration < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true
  belongs_to :user_team, optional: true

  enum :status, { confirmed: 0, waitlist: 1, cancelled: 2 }

  validate :team_capacity
  validate :team_size_within_member_count
  validate :no_duplicate_match_registration

  private

  def no_duplicate_match_registration
    match = team.match

    # If this is an individual registration
    if user.present?
      if match.registrations.where(user_id: user.id).exists?
        errors.add(:base, "Du är redan anmäld till denna match.")
      end
    end

    # If this is a team registration
    if user_team.present?
      member_ids = user_team.members.pluck(:id)

      if match.registrations.where(user_id: member_ids).exists?
        errors.add(:base, "En eller flera medlemmar i laget är redan anmälda till denna match.")
      end
    end
  end

  def team_capacity
    if team.hard_limit_reached?
      errors.add(:base, "Team is full.")
    elsif team.match.hard_limit_reached?
      errors.add(:base, "Match is full.")
    end
  end

  def team_size_within_member_count
    return unless user_team && team_size.present?

    if team_size > user_team.members.count
      errors.add(:team_size, "cannot exceed the number of members in the team (#{user_team.members.count})")
    elsif team_size < 1
      errors.add(:team_size, "must be at least 1")
    end
  end
end
