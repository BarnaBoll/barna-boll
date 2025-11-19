class MatchMailer < ApplicationMailer
  # Individual registration
  def individual_registration(registration_id)
    @registration = Registration
                      .includes(:user, team: :match)
                      .find(registration_id)
    @match = @registration.team.match
    @user  = @registration.user

    attachments["barnaboll-match-#{@match.id}.ics"] = generate_ics(@match)

    mail(
      to: @user.email,
      subject: "Du är anmäld till #{@match.title}"
    )
  end

  # Team registration – per recipient
  def team_registration(registration_id, recipient_user_id)
    @registration = Registration
                      .includes(:user_team, :user, team: :match)
                      .find(registration_id)
    @match          = @registration.team.match
    @team           = @registration.user_team
    @recipient_user = User.find(recipient_user_id)
    @submitted_by   = @registration.user

    attachments["barnaboll-match-#{@match.id}.ics"] = generate_ics(@match)

    mail(
      to: @recipient_user.email,
      subject: "#{@team.name} är anmält till #{@match.title}"
    )
  end

  private

  def generate_ics(match)
    # Build start/end times in app time zone
    start_time =
      if match.time.present?
        Time.zone.local(match.date.year, match.date.month, match.date.day,
                        match.time.hour, match.time.min)
      else
        match.date.to_time.change(hour: 18) # default 18:00
      end

    end_time = start_time + 90.minutes

    uid = "barnaboll-match-#{match.id}@barnaboll.se"

    <<~ICS
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//Barnaboll//Matches//EN
      CALSCALE:GREGORIAN
      METHOD:PUBLISH
      BEGIN:VEVENT
      UID:#{uid}
      DTSTART:#{start_time.utc.strftime('%Y%m%dT%H%M%SZ')}
      DTEND:#{end_time.utc.strftime('%Y%m%dT%H%M%SZ')}
      SUMMARY:#{escape_ics_text(match.title)}
      DESCRIPTION:#{escape_ics_text(match.description.to_s)}
      LOCATION:#{escape_ics_text("#{match.location.name}, #{match.city.name}")}
      STATUS:CONFIRMED
      BEGIN:VALARM
      ACTION:DISPLAY
      DESCRIPTION:Påminnelse
      TRIGGER:-PT30M
      END:VALARM
      END:VEVENT
      END:VCALENDAR
    ICS
  end

  def escape_ics_text(text)
    text.to_s.gsub(/([,;\\])/, '\\\\\1').gsub(/\r?\n/, "\\n")
  end
end
