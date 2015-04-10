class Nunu
  def self.consume(region:, bucket_time:)
    client = Taric.client(region: region)
    match_ids = client.api_challenge_match_ids(begin_date: bucket_time)
    UrfIdsRequest.create_with(response: match_ids).find_or_create_by(region: region, bucket_time: bucket_time) unless match_ids.empty?
    match_ids
  rescue Taric::FaradayMiddleware::NotFound => e
    puts "No record was found for #{region} at #{bucket_time} - #{e}"
    []
  end
end