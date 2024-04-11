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
FactoryBot.define do
  factory :config_delivery do
    delivery_forecast { 30 }
    delivery_fee { 6 }
    opening_time { Time.zone.parse('08:00') }
    closing_time { Time.zone.parse('23:59') }
    association :client, factory: :client
    deleted_at { nil }
  end
end
