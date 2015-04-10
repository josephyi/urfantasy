class CreateUrfDayStatLogs < ActiveRecord::Migration
  def change
    create_table :urf_day_stat_logs do |t|
      t.string :region
      t.integer :urf_day
      t.integer :hour_in_day
      t.integer :matches

      t.timestamps null: false
    end
    add_index :urf_day_stats, [:urf_day, :hour_in_day, :region], name: 'urf_day_stat_log_idx'
  end
end
