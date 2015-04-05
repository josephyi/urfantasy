class Team < OpenStruct
  POINTS_PER_WIN = 2
  POINTS_PER_BARON = 2
  POINTS_PER_DRAGON = 1
  POINTS_PER_FIRST_BLOOD = 2
  POINTS_PER_TOWER = 1
  POINTS_PER_30MIN = 2
  attr_accessor :champions

  def to_hash
    {
      total_score: self.total_score,
      id: self.teamId,
      champions: self.champions
    }
  end

  def total_score
    win_score +
    baron_score +
    dragon_score +
    first_blood_score +
    tower_score +
    timer_score
  end

  def win_score
    self.winner ? POINTS_PER_WIN : 0
  end

  def baron_score
    self.baronKills * POINTS_PER_BARON
  end

  def dragon_score
    self.dragonKills * POINTS_PER_DRAGON
  end

  def first_blood_score
    self.firstBlood ? POINTS_PER_FIRST_BLOOD : 0
  end

  def tower_score
    self.towerKills * POINTS_PER_TOWER
  end

  def timer_score
    0 # this comes from the match and not the team, need to figure this out
  end

end