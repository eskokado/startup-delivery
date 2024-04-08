class AddDeletedAtToConsumers < ActiveRecord::Migration[7.0]
  def change
    add_column :consumers, :deleted_at, :datetime
    add_index :consumers, :deleted_at
  end
end
