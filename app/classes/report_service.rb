class ReportService
  def self.champion_report(champion_id)
    {
        avg_death_stats: avg_stat(champion_id, 'deaths', 'ASC').to_a,
        avg_kill_stats: avg_stat(champion_id, 'kills').to_a,
        win_rates: win_rate(champion_id).to_a
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

    ActiveRecord::Base.connection.execute sql
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

    ActiveRecord::Base.connection.execute sql
  end
end