class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.integer :quantity
      t.datetime :last_activity_at

      t.timestamps
    end
  end
end
