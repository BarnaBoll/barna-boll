# app/models/match.rb
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
  after_commit :schedule_reminder_job, on: %i[create update]

  def total_players
    registrations.confirmed.sum(:team_size)
  end

  def hard_limit_reached?
    total_players >= hard_limit_total
  end

  # Helper for full start time
  def starts_at
    return nil if date.blank?

    if time.present?
      Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
    else
      date.to_time.change(hour: 18) # fallback 18:00
    end
  end

  # When should the reminder be sent?
  def reminder_send_at
    return nil if reminder_offset_minutes.blank?
    return nil if starts_at.blank?

    send_at = starts_at - reminder_offset_minutes.minutes
    # Don’t schedule in the past
    send_at if send_at > Time.current
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

  # Schedule reminder job
  def schedule_reminder_job
    send_at = reminder_send_at
    return unless send_at

    MatchReminderJob.set(wait_until: send_at).perform_later(id)
  end
end
