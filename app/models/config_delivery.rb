# == Schema Information
#
# Table name: config_deliveries
#
#  id                :bigint           not null, primary key
#  closing_time      :time
#  deleted_at        :datetime
#  delivery_fee      :decimal(, )
#  delivery_forecast :integer
#  opening_time      :time
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_id         :bigint           not null
#
# Indexes
#
#  index_config_deliveries_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class ConfigDelivery < ApplicationRecord
  acts_as_paranoid

  belongs_to :client

  validates :opening_time, :closing_time,
            :delivery_forecast, :delivery_fee, presence: true
  validates :delivery_forecast, :delivery_fee,
            numericality: { greater_than: 0 }
end
