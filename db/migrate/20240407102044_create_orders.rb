class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :total
      t.decimal :total_paid
      t.decimal :change
      t.string :payment_type
      t.date :date
      t.time :time
      t.string :status
      t.string :paid
      t.text :notes
      t.decimal :fixed_delivery
      t.references :client, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
