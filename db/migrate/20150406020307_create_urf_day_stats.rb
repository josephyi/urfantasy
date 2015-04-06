class CreateUrfDayStats < ActiveRecord::Migration
  def change
    create_table :urf_day_stats do |t|
      t.integer :champion_id
      t.string :region
      t.integer :urf_day
      t.integer :hour_in_day

      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :double_kills
      t.integer :triple_kills
      t.integer :quadra_kills
      t.integer :penta_kills
      t.integer :killing_spree_max
      t.integer :first_blood
      t.integer :minions_killed
      t.integer :bans
      t.integer :wins
      t.integer :losses
      t.integer :mirror_matches
    end

    add_index :urf_day_stats, [:champion_id, :urf_day, :hour_in_day, :region], name: 'urf_day_stats_idx'
  end
end
