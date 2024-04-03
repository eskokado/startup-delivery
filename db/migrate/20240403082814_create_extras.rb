class CreateExtras < ActiveRecord::Migration[7.0]
  def change
    create_table :extras do |t|
      t.string :name
      t.decimal :value
      t.references :category, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
