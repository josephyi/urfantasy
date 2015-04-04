class Match < OpenStruct
  extend Memoist

  def teams
    to_ret = []
    # Teams method already exists because that is the name of the json property
    super.each do |team|
      to_ret << Team.new(team)
    end
    to_ret
  end
  memoize :teams

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