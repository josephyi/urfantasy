class UrfStatService
  CONNECTION = ActiveRecord::Base.connection

  def self.delete_for(region:, day:, hour:)
    UrfDayStat.where('region = ? AND urf_day = ? AND hour_in_day = ?', region, day, hour).delete_all
  end

  # move to scope later
  def self.matches(start_time:, end_time:)
    UrfMatch.where('bucket_time >= ? AND bucket_time < ?', start_time, end_time)
  end

  #
  # @param [Hash] aggregate_stats
  def self.insert_all(aggregate_stats:)
    CONNECTION.execute insert_all_query(aggregate_stats)
  end

  def self.insert_all_query(aggregate_stats:)
    values = aggregate_stats.keys.map{|k|
      %Q[(
        #{k},
        '#{aggregate_stats[k][:region]}',
        #{aggregate_stats[k][:urf_day]},
        #{aggregate_stats[k][:hour_in_day]},
        #{aggregate_stats[k][:kills]},
        #{aggregate_stats[k][:deaths]},
        #{aggregate_stats[k][:assists]},
        #{aggregate_stats[k][:double_kills]},
        #{aggregate_stats[k][:triple_kills]},
        #{aggregate_stats[k][:quadra_kills]},
        #{aggregate_stats[k][:penta_kills]},
        #{aggregate_stats[k][:killing_spree_max]},
        #{aggregate_stats[k][:first_blood]},
        #{aggregate_stats[k][:minions_killed]},
        #{aggregate_stats[k][:bans]},
        #{aggregate_stats[k][:wins]},
        #{aggregate_stats[k][:losses]},
        #{aggregate_stats[k][:mirror_matches]}
      )]
    }

    %Q[
        INSERT INTO urf_day_stats (
        champion_id, region, urf_day, hour_in_day,
        kills, deaths, assists,
        double_kills, triple_kills, quadra_kills, penta_kills, killing_spree_max, first_blood,
        minions_killed, bans, wins, losses, mirror_matches) VALUES
        #{values.join(', ')}
    ].gsub(/\s+/, ' '.freeze).strip
  end
end