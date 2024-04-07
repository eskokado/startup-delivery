# == Schema Information
#
# Table name: order_items
#
#  id         :bigint           not null, primary key
#  date       :date
#  document   :string
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (product_id => products.id)
#
FactoryBot.define do
  factory :order_item do
    association :order, factory: :order
    association :product, factory: :product
    document { FFaker::IdentificationBR.pretty_cpf }
    quantity { rand(1..10) }
    date { FFaker::Time.date }
  end
end
