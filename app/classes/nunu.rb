class Nunu
  def self.consume(region:, bucket_time:, callback: callback)
    client = Taric.client(region: region)
    match_ids = client.api_challenge_match_ids(begin_date: bucket_time)

    result = UrfIdsRequest.where(region: region, bucket_time: bucket_time).first
    UrfIdsRequest.create!(region: region, response: match_ids, bucket_time: bucket_time) if result.nil?
    match_ids
  end
end