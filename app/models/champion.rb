class Champion < OpenStruct
  extend Memoist

  POINTS_PER_KILL = 2
  POINTS_PER_DEATH = -0.5
  POINTS_PER_ASSIST = 1.5
  POINTS_PER_CREEP_KILL = 0.01
  POINTS_PER_TRIPLE_KILL = 2
  POINTS_PER_QUADRA_KILL = 5
  POINTS_PER_PENTA_KILL = 10
  GAME_BONUS = 2

  def to_hash
    {
      total_score: self.total_score,
      id: self.championId,
      name: self.champion['name'],
      key: self.champion['key']
    }
  end

  def champion
    Taric.client(region:'na').static_champion(id: self.championId)
  end
  memoize :champion

  def total_score
    kill_score +
    death_score +
    triple_kill_score +
    quadra_kill_score +
    penta_kill_score +
    game_bonus
  end

  def kill_score
    self.stats['kills'] * POINTS_PER_KILL
  end

  def death_score
    self.stats['deaths'] * POINTS_PER_DEATH
  end

  def triple_kill_score
    self.stats['tripleKills'] * POINTS_PER_TRIPLE_KILL
  end

  def quadra_kill_score
    self.stats['quadraKills'] * POINTS_PER_QUADRA_KILL
  end

  def penta_kill_score
    self.stats['pentaKills'] * POINTS_PER_PENTA_KILL
  end

  def game_bonus
    self.stats['kills'] > 10 || self.stats['assists'] > 10 ? GAME_BONUS : 0
  end

end