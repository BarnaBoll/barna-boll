class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, foreign_key: true # optional
      t.integer :team_size, null: false, default: 1
      t.integer :status, default: 0, null: false # enum
      t.timestamps
    end
  end
end
