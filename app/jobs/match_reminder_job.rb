# app/jobs/match_reminder_job.rb
class MatchReminderJob < ApplicationJob
  queue_as :default

  def perform(match_id)
    match = Match.includes(teams: { registrations: { user_team: :members } }).find(match_id)

    # Don’t send twice
    return if match.reminder_sent_at.present?

    # If match already started, bail out
    return if match.starts_at.present? && match.starts_at <= Time.current

    recipients = []

    # Only confirmed registrations
    match.teams.each do |team|
      team.registrations.confirmed.includes(:user, user_team: :members).each do |registration|
        if registration.user_team.present?
          registration.user_team.members.each { |member| recipients << member }
        elsif registration.user.present?
          recipients << registration.user
        end
      end
    end

    # Unique users by id
    recipients.uniq! { |u| u.id }

    recipients.each do |user|
      MatchMailer.match_reminder(match.id, user.id).deliver_later
    end

    match.update!(reminder_sent_at: Time.current)
  end
end
