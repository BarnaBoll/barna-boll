class CreatePlayerStats < ActiveRecord::Migration[8.1]
  def change
    create_table :player_stats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.integer :matches_played, default: 0
      t.integer :wins, default: 0
      t.integer :losses, default: 0
      t.timestamps
    end

    add_index :player_stats, [ :user_id, :city_id, :location_id ], unique: true, name: "index_stats_unique"
  end
end
