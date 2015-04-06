
class Bard
  include Sidekiq::Worker
  sidekiq_options queue: :bard

  URF_DAY_1_EPOCH = 1427871600

  DAY_OF_URF = -> bucket_time {
    (bucket_time - URF_DAY_1_EPOCH)/86400 + 1
  }

  HOUR_OF_URF = -> bucket_time {
    Time.at(bucket_time - 7.hours.to_i).hour + 1
  }

  CHAMPION_IDS = StaticData::CHAMPION_IDS

  def perform(region, bucket_time)
    day = DAY_OF_URF.(bucket_time)
    hour = HOUR_OF_URF.(bucket_time)

    UrfStatService.delete_all(region: region, day: day, hour: hour)
    matches = UrfStatService.matches(start_time: bucket_time, end_time: bucket_time + 86400)
    stats = UrfStatAggregator.aggregate(region: region, day: day, hour: hour, matches: matches)
    UrfStatService.insert_all(aggregate_stats: stats)
  end
end