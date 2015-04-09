class Chogath
  def self.feast(region:, match_ids:, bucket_time: )
    to_get = diff(region: region, match_ids: match_ids)
    parallel_client = Taric.client(region: region).in_parallel
    to_get.each{|id| parallel_client.match(id: id)}
    responses = parallel_client.execute!
    insert_all(region: region, responses: responses, bucket_time: bucket_time)
  end

  def self.diff(region:, match_ids:)
    match_ids - UrfMatch.where(region: region, match_id: match_ids).pluck(:match_id)
  end

  def self.insert_all(region:, responses:, bucket_time:)
    to_process = responses.select{|response| response[:status] == 200}
    ActiveRecord::Base.connection.execute insert_stmt(region: region, responses: to_process, bucket_time: bucket_time) unless to_process.empty?
  end

  def self.insert_stmt(region:, responses:, bucket_time:)
    values = responses.map{|response| "('#{region}', #{response[:body]['matchId']}, #{bucket_time}, '#{response[:body].to_json}', now(), now())"}
    "INSERT INTO urf_matches (region, match_id, bucket_time, response, created_at, updated_at) VALUES #{values.join(', ')}"
  end
end
