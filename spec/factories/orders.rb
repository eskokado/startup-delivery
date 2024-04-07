# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  change         :decimal(, )
#  date           :date
#  deleted_at     :datetime
#  fixed_delivery :decimal(, )
#  notes          :text
#  paid           :string
#  payment_type   :string
#  status         :string
#  time           :time
#  total          :decimal(, )
#  total_paid     :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  client_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :order do
    total { FFaker::Number.decimal(whole_digits: 2, fractional_digits: 2) }
    total_paid { FFaker::Number.decimal(whole_digits: 2, fractional_digits: 2) }
    change { 0 }
    payment_type { ['Cash', 'CreditCard', 'DebitCard', 'Transfer'].sample }
    date  { FFaker::Time.date }
    time { FFaker::Time.datetime }
    status { ["Pending", "Completed", "Cancelled"].sample }
    paid { ["Yes", "No"].sample }
    notes { FFaker::Lorem.paragraph }
    fixed_delivery { FFaker::Number.decimal(whole_digits: 1) }
    association :client, factory: :client
    deleted_at { nil }
  end
end
