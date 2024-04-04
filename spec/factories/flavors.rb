# == Schema Information
#
# Table name: flavors
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_flavors_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :flavor do
    name { FFaker::Product.product_name }
    value { FFaker::Number.decimal(whole_digits: 2, fractional_digits: 2) }
    association :client, factory: :client
    deleted_at { nil }
  end
end
