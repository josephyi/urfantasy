class Zilean
  include Sidekiq::Worker
  sidekiq_options queue: :zilean

  def perform(bucket_time)
    StaticData::REGIONS.each do |region|
      -> match_ids {
        Chogath.feast(region: region, bucket_time: bucket_time, match_ids: match_ids) unless match_ids.empty?
      }.(Nunu.consume(region: region, bucket_time: bucket_time))
    end
  end
end
