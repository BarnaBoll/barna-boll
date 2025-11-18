class Team < ApplicationRecord
  belongs_to :match
  has_many :registrations

  def current_players
    registrations.confirmed.sum(:team_size)
  end

  def soft_limit_reached?
    current_players >= capacity_soft
  end

  def hard_limit_reached?
    capacity_hard.present? && current_players >= capacity_hard
  end
end
