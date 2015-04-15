class UrfDayStat < ActiveRecord::Base
  extend Memoist

  POINTS_PER_KILL = 2
  POINTS_PER_DEATH = -1
  POINTS_PER_ASSIST = 0.5
  POINTS_PER_CREEP_KILL = 0.01
  POINTS_PER_TRIPLE_KILL = 2
  POINTS_PER_QUADRA_KILL = 5
  POINTS_PER_PENTA_KILL = 10
  GAME_BONUS = 2
  AGGREGATE_SQL = 'champion_id,
      sum(kills) AS kills,
      sum(deaths) as deaths,
      sum(assists) as assists,
      sum(triple_kills) as triple_kills,
      sum(quadra_kills) as quadra_kills,
      sum(penta_kills) as penta_kills,
      sum(minions_killed) as minions_killed,
      sum(wins) as wins,
      sum(losses) as losses,
      sum(bans) as bans'

  # production match count
  TOTAL_MATCHES = 491322

  def to_hash(total_match_count)
    {
      key: key,
      name: name,
      id: champion_id,
      matches: matches,
      wins: wins,
      losses: losses,
      score: score,
      average_score: average_score,
      kills: kills,
      average_kills: average_kills,
      deaths: deaths,
      average_deaths: average_deaths,
      assists: assists,
      average_assists: average_assists,
      triple_kills: triple_kills,
      average_triple_kills: average_triple_kills,
      quadra_kills: quadra_kills,
      average_quadra_kills:  average_quadra_kills,
      penta_kills: penta_kills,
      average_penta_kills: average_penta_kills,
      minions_killed: minions_killed,
      average_minions_killed: average_minions_killed,
      kda: kda.round(2),
      ban_rate: ban_rate(total_match_count).round(2),
      pick_rate: pick_rate(total_match_count).round(2)
    }
  end

  def day_hash
    {
      day: urf_day,
      hour: hour_in_day
    }
  end

  def self.aggregate_relation(args)
    select(AGGREGATE_SQL).where(args).group(:champion_id)
  end

  def self.aggregate_single(args)
    match_count = UrfMatch.where({region: args[:region]}.compact).count
    aggregate_relation(args).take.to_hash(match_count)
  end

  def self.aggregate_all(args)
    match_count = UrfMatch.where({region: args[:region]}.compact).count
    aggregate_relation(args).all.to_a.map{|champ| champ.to_hash(match_count)}
  end

  def self.aggregate_historical(args)
    self.select('urf_day, hour_in_day,'+AGGREGATE_SQL)
        .where(args)
        .group(:urf_day).group(:champion_id).group(:hour_in_day)
        .to_a.sort{|a,b| a.hour_in_day <=> b.hour_in_day}.sort{|a,b| a.urf_day <=> b.urf_day}
        .map{|champ|champ.to_hash.merge(champ.day_hash)}
  end

  def self.day_aggregate_all(args)
    self.select(AGGREGATE_SQL).where(urf_day: args[:urf_day]).group(:champion_id).all
  end

  def self.day_leaderboard(args)
    aggregate_relation(args)
        .to_a.sort_by{ |a| a.average_score }.reverse!
        .map{|champ| champ.to_hash}
  end

  def name
    StaticData::CHAMPIONS_ID_TO_NAME[champion_id][:name]
  end

  def key
    StaticData::CHAMPIONS_ID_TO_NAME[champion_id][:key]
  end

  def matches
    wins + losses
  end

  def score
    kill_score +
    death_score +
    assist_score +
    triple_kill_score +
    quadra_kill_score +
    penta_kill_score +
    creep_score
  end

  def kill_score
    kills * POINTS_PER_KILL
  end

  def death_score
    deaths * POINTS_PER_DEATH
  end

  def assist_score
    assists * POINTS_PER_ASSIST
  end

  def kda
    (kills + assists).to_f / deaths
  end

  def triple_kill_score
    triple_kills * POINTS_PER_TRIPLE_KILL
  end

  def quadra_kill_score
    quadra_kills * POINTS_PER_QUADRA_KILL
  end

  def penta_kill_score
    penta_kills * POINTS_PER_PENTA_KILL
  end

  def creep_score
    minions_killed * POINTS_PER_CREEP_KILL
  end

  def ban_rate(total_match_count)
    (100 * bans / total_match_count.to_f)
  end

  # For 1 match, a champ can be picked twice, so match count is doubled for maths
  #
  def pick_rate(total_match_count)
    (wins + losses * 100) / (total_match_count * 2).to_f
  end

  # Can't do game bonus. D'Oh!
  # def game_bonus
  #   self.stats['kills'] > 10 || self.stats['assists'] > 10 ? GAME_BONUS : 0
  # end

  def method_missing(symbol, *args)
    symbol_str = symbol.to_s

    # Get average stats with average_[stat]
    if symbol_str.start_with?('average_')
      return 0 if self.matches == 0
      return (self.send(symbol_str.gsub('average_','')) / self.matches).round(2)
    else
      super
    end
  end

end
