class CreateUrfMatches < ActiveRecord::Migration
  def change
    create_table :urf_matches do |t|
      t.string :region
      t.integer :match_id
      t.integer :bucket_time
      t.jsonb :response

      t.timestamps null: false
    end

    add_index :urf_matches, [:region, :match_id, :bucket_time]
    add_index :urf_matches, :response, using: :gin
  end
end
