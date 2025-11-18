class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.references :city, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address
      t.text :description
      t.timestamps
    end
  end
end
