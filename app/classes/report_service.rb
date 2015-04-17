require 'memoist'
class ReportService
  def self.champion_report(champion_id)
    {
        avg_death_stats: avg_stat(champion_id, 'deaths', 'ASC'),
        avg_kill_stats: avg_stat(champion_id, 'kills'),
        avg_assists_stats: avg_stat(champion_id, 'assists'),
        ban_rates: ban_rates(champion_id),
        win_rates: win_rate(champion_id),
        pick_ban_ratio: pick_ban_ratio(champion_id),
        penta_kills: penta_kills_ratio(champion_id)
    }
  end

  def self.avg_stat(champion_id, stat, stat_order = 'DESC')
    sql = %Q[
    SELECT region, SUM(#{stat})::float / SUM(wins+losses) AS avg_#{stat}
    FROM urf_day_stats
    WHERE champion_id = #{champion_id}
    GROUP BY region
    HAVING SUM(wins + losses) > 0
    ORDER BY avg_#{stat} #{stat_order}, REGION ASC
    ]

    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def self.win_rate(champion_id)
    sql = %Q[
    SELECT region, 100 * SUM(wins)::float/SUM(wins+losses) AS win_rate
    FROM urf_day_stats
    WHERE champion_id = #{champion_id}
    GROUP BY region
    HAVING SUM(wins + losses) > 0
    ORDER BY win_rate DESC, REGION ASC
    ]

    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def self.ban_rates(champion_id)
    sql = %Q[
    SELECT region, SUM(bans) AS region_bans
    FROM urf_day_stats
    WHERE champion_id = #{champion_id}
    GROUP BY region
    ORDER BY region_bans DESC, REGION ASC
    ]

    bans = ActiveRecord::Base.connection.execute(sql).to_a

    matches_by_region.map{|a| {a['region'.freeze] => a['match_count'.freeze].to_i}}.reduce(:merge).merge(
      bans.map{|a| {a['region'] => a['region_bans'.freeze].to_i}}.reduce(:merge)
    ){|k, v1, v2| 100.to_f * v2 / v1}.map{|k, v| {'region'.freeze => k, 'ban_rate'.freeze => v}}
  end

  def self.pick_ban_ratio(champion_id)
    matches_by_region.map{|a| {a['region'.freeze] => a['match_count'.freeze].to_i}}.reduce(:merge).merge(
        unique_match_presence(champion_id).map{|a| {a['region'] => a['match_count'.freeze].to_i}}.reduce(:merge)
    ){|k, v1, v2| v2 * 100.to_f / v1}.map{|k, v| {'region'.freeze => k, 'pick_ban_ratio'.freeze => v}}.sort_by {
      |entry| entry['pick_ban_ratio'.freeze]
    }.reverse!
  end

  def self.penta_kills_ratio(champion_id)
    sql = %Q[
    SELECT region, SUM(penta_kills) AS region_penta_kills
    FROM urf_day_stats
    WHERE champion_id = #{champion_id}
    GROUP BY region
    ORDER BY region_penta_kills DESC, REGION ASC
    ]

    result = ActiveRecord::Base.connection.execute(sql).to_a
    matches_by_region.map{|a| {a['region'.freeze] => a['match_count'.freeze].to_i}}.reduce(:merge).merge(
        result.map{|a| {a['region'] => a['region_penta_kills'.freeze].to_i}}.reduce(:merge)
    ){|k, v1, v2| v2.to_f / v1}.map{|k, v| {'region'.freeze => k, 'penta_kills_ratio'.freeze => v}}.sort_by {
        |entry| entry['penta_kills_ratio'.freeze]
    }.reverse!
  end

  class << self
    extend Memoist
    def matches_by_region
      sql = 'SELECT region, count(id) match_count from urf_matches group by region'.freeze
      ActiveRecord::Base.connection.execute(sql).to_a
    end
    memoize :matches_by_region
  end

  def self.unique_match_presence(champion_id)
    sql = %Q[
    SELECT region, sum(bans + wins + losses - mirror_matches) AS match_count
    FROM urf_day_Stats
    WHERE champion_id = #{champion_id}
    GROUP BY region]
    ActiveRecord::Base.connection.execute(sql).to_a
  end
end