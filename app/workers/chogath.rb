class Chogath
  include Sidekiq::Worker
  sidekiq_options queue: :chogath, throttle: ApiSettings::THROTTLE

  def perform(region, bucket_time, match_id)
    urfmatch = match_id ? UrfMatch.where(region: region, match_id: match_id).first : nil
    if urfmatch.nil? && match_id.present?
      match = Taric.client(region: region).match(id: match_id)
      UrfMatch.create!(region: region, match_id: match_id, bucket_time: bucket_time, response: match)
    end
  end
end