# == Schema Information
#
# Table name: order_items
#
#  id         :bigint           not null, primary key
#  date       :date
#  deleted_at :datetime
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
class OrderItem < ApplicationRecord
  acts_as_paranoid

  belongs_to :order
  belongs_to :product

  validates :document, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
