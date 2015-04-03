class CreateUrfIdsRequests < ActiveRecord::Migration
  def change
    create_table :urf_ids_requests do |t|
      t.string :region
      t.integer :bucket_time
      t.json :response

      t.timestamps null: false
    end

    add_index :urf_ids_requests, [:region, :bucket_time]
  end
end
