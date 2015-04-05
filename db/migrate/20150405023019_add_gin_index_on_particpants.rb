class AddGinIndexOnParticpants < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE INDEX urf_matches_response_participants_index ON urf_matches USING GIN ((response->'participants'))
    SQL
  end
end
