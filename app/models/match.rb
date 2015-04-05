class Match < OpenStruct
  extend Memoist

  def initialize(args)
    super

    # Shitty exponential time, but whatevs
    teams.map!{|team| Team.new(team)}
    teams.each do |team|
      to_ret = []
      champions.each do |champion|
        to_ret << champion if team.teamId == champion.teamId
      end
      team.champions = to_ret
    end
  end

  def to_hash
    {
      teams: self.teams,
      leaderboard: self.leaderboard,
      matchId: matchId
    }
  end

  def champions
    to_ret = []
    participants.each do |participant|
      to_ret << Champion.new(participant)
    end
    to_ret
  end
  memoize :champions

  def leaderboard
    champions.sort{ |a,b| b.total_score <=> a.total_score }
  end
  memoize :leaderboard

end