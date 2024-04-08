class CreateConsumers < ActiveRecord::Migration[7.0]
  def change
    create_table :consumers do |t|
      t.string :name
      t.string :document
      t.string :phone
      t.string :email
      t.string :street
      t.string :number
      t.string :district
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :complement
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
