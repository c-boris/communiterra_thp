class CreateKeptPlants < ActiveRecord::Migration[7.0]
  def change
    create_table :kept_plants do |t|
      t.references :owned_plant, null: false, foreign_key: { on_delete: :cascade }
      t.references :plant_sitting, foreign_key: { on_delete: :cascade }, null: true
      t.integer :quantity
      t.date :start_date
      t.date :end_date
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
