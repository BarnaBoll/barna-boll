class CreateCities < ActiveRecord::Migration[8.1]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.text :description
      t.string :color
      t.timestamps
    end
  end
end
