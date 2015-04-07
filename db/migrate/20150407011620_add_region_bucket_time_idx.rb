class AddRegionBucketTimeIdx < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE INDEX urf_match_region_bucket_time_idx ON urf_matches(region, bucket_time DESC)
    SQL
  end
end
