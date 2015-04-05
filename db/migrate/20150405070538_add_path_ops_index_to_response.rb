class AddPathOpsIndexToResponse < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE INDEX urf_matches_gin_path_idx ON urf_matches USING GIN (response jsonb_path_ops)
    SQL
  end
end
