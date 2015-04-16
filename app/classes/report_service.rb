class ReportService
  def self.champion_report(champion_id)
    {
        avg_death_stats: avg_stat(champion_id, 'deaths', 'ASC').to_a,
        avg_kill_stats: avg_stat(champion_id, 'kills').to_a
    }
  end

  def self.avg_stat(champion_id, stat, stat_order = 'DESC')
sql = %Q[SELECT region, SUM(#{stat})::float / SUM(wins+losses) AS avg_#{stat} FROM urf_day_stats AS #{stat}
WHERE champion_id = #{champion_id}
GROUP BY region
HAVING SUM(wins + losses) > 0
ORDER BY avg_#{stat} #{stat_order}, REGION ASC
]
    ActiveRecord::Base.connection.execute sql
  end
end