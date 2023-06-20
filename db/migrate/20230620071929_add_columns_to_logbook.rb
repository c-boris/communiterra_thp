class AddColumnsToLogbook < ActiveRecord::Migration[7.0]
  def change
    add_column :log_books, :mood, :integer, default: 0
    add_column :log_books, :watered, :boolean, default: false
  end
end
