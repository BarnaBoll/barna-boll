class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :city, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.date :date
      t.time :time
      t.integer :soft_limit_per_team, default: 5, null: false
      t.integer :hard_limit_total, null: false
      t.integer :teams_count, default: 3, null: false
      t.timestamps
    end
  end
end
