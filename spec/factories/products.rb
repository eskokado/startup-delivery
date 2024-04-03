# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  combo            :boolean
#  deleted_at       :datetime
#  description      :string
#  long_description :text
#  name             :string
#  pizza            :boolean
#  value            :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  category_id      :bigint           not null
#  client_id        :bigint           not null
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#  index_products_on_client_id    (client_id)
#  index_products_on_deleted_at   (deleted_at)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :product do
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.sentence }
    long_description { FFaker::Lorem.paragraph }
    value { FFaker::Number.decimal(whole_digits: 2, fractional_digits: 2) }
    association :category, factory: :category
    association :client, factory: :client
    combo { false }
    pizza { false }
    deleted_at { nil }
  end
end
