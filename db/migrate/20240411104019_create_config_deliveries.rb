class CreateConfigDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :config_deliveries do |t|
      t.integer :delivery_forecast
      t.decimal :delivery_fee
      t.time :opening_time
      t.time :closing_time
      t.references :client, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
