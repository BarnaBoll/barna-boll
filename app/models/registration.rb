class Registration < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  enum :status, { confirmed: 0, waitlist: 1, cancelled: 2 }

  validate :team_capacity

  private

  def team_capacity
    if team.hard_limit_reached?
      errors.add(:base, "Team is full.")
    elsif team.match.hard_limit_reached?
      errors.add(:base, "Match is full.")
    end
  end
end
