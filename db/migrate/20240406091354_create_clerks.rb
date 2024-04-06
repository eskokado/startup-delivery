class CreateClerks < ActiveRecord::Migration[7.0]
  def change
    create_table :clerks do |t|
      t.string :name
      t.string :document
      t.string :phone
      t.string :person
      t.references :client, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
