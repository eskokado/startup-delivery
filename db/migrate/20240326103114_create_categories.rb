class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.references :client, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :categories, :deleted_at
  end
end
