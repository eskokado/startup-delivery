class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.text :long_description
      t.decimal :value
      t.references :category, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.boolean :combo
      t.boolean :pizza
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :products, :deleted_at
  end
end
