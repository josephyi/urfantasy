class UrfStatService
  def self.aggregate_hour(region:, day:, hour:, start_time:, end_time:)
    delete_all(region: region, day: day, hour: hour)

    stats = init_stats(region: region, hour: hour, day: day)
    UrfMatch.in_region_and_between(region, start_time, end_time).find_in_batches(batch_size: 200) do |group|
      UrfStatAggregator.process_matches!(stats: stats, matches: group)
    end
    insert_all(aggregate_stats: stats)

    match_count = UrfMatch.in_region_and_between(region, start_time, end_time).count
    UrfDayStatLog.find_or_initialize_by(region: region, urf_day: day, hour_in_day: hour).update(matches: match_count)
  end

  def self.init_stats(region:, hour:, day:)
    StaticData::CHAMPION_IDS.each_with_object({}) do |id, hash|
      hash[id] = {
          region: region,
          hour_in_day: hour,
          urf_day: day,
          kills: 0,
          deaths: 0,
          assists: 0,
          double_kills: 0,
          triple_kills: 0,
          quadra_kills: 0,
          penta_kills: 0,
          killing_spree_max: 0,
          first_blood: 0,
          minions_killed: 0,
          bans: 0,
          wins: 0,
          losses: 0,
          mirror_matches: 0
      }
    end
  end

  def self.delete_all(region:, day:, hour:)
    UrfDayStat.where('region = ? AND urf_day = ? AND hour_in_day = ?', region, day, hour).delete_all
  end

  #
  # @param [Hash] aggregate_stats
  def self.insert_all(aggregate_stats:)
    ActiveRecord::Base.connection.execute insert_all_query(aggregate_stats: aggregate_stats)
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