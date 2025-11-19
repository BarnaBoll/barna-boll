# app/mailers/team_mailer.rb
class TeamMailer < ApplicationMailer
  # Sends an email when a member is added to a team
  #
  # We pass membership_id so this plays nicely with deliver_later
  def member_added(membership_id)
    @membership = UserTeamMembership.includes(:user, :user_team).find(membership_id)
    @team       = @membership.user_team
    @member     = @membership.user
    @creator    = @team.creator

    mail(
      to:      @member.email,
      subject: "Du har lagts till i laget #{@team.name}"
    )
  end
end
