class Nunu
  include Sidekiq::Worker
  sidekiq_options queue: :nunu, throttle: ApiSettings::THROTTLE

  def perform(region, bucket_time)
    client = Taric.client(region: region)
    match_ids = client.api_challenge_match_ids(begin_date: bucket_time)

    result = UrfIdsRequest.where(region: region, bucket_time: bucket_time).first
    UrfIdsRequest.create!(region: region, response: match_ids, bucket_time: bucket_time) if result.nil?

    Chogath.feast(region: region, bucket_time: bucket_time, match_ids: match_ids)
  rescue Taric::FaradayMiddleware::NotFound => e
    puts "No record found for #{region} at #{bucket_time} - #{e}"
  end
end