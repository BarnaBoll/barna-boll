# app/services/match_result_service.rb
class MatchResultService
  def record(match, results)
    match.registrations.confirmed.each do |reg|
      next unless reg.user # skip if you ever allow anonymous/group-only regs

      stat = PlayerStat.find_or_create_by!(
        user: reg.user,
        city: match.city,
        location: match.location
      )

      stat.increment!(:matches_played)

      if results[:winner_team_id] == reg.team_id
        stat.increment!(:wins)
      else
        stat.increment!(:losses)
      end
    end
  end
end
