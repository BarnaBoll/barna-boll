class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.references :match, null: false, foreign_key: true
      t.string :name
      t.integer :capacity_soft, default: 5
      t.integer :capacity_hard
      t.timestamps
    end
  end
end
