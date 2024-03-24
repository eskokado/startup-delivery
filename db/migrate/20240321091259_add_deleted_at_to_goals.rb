class AddDeletedAtToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :deleted_at, :datetime
    add_index :goals, :deleted_at
  end
end
