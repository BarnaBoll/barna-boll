class Match < ApplicationRecord
  belongs_to :city
  belongs_to :location
  has_many :teams
  has_many :registrations, through: :teams

  validates :title, presence: true
  validates :city, :location, :hard_limit_total, presence: true
  validates :soft_limit_per_team, numericality: { greater_than: 0 }
  validates :teams_count, numericality: { greater_than: 0 }

  validate :location_belongs_to_city

  before_create :build_default_teams

  def total_players
    registrations.confirmed.sum(:team_size)
  end

  def hard_limit_reached?
    total_players >= hard_limit_total
  end

  private

  def build_default_teams
    (teams_count || 3).times do |i|
      teams.build(name: "Team #{('A'.ord + i).chr}", capacity_soft: soft_limit_per_team)
    end
  end

  def location_belongs_to_city
    return if location.blank? || city.blank?

    if location.city_id != city_id
      errors.add(:location, "måste tillhöra samma stad som matchen")
    end
  end
end
