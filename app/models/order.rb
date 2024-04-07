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
class Order < ApplicationRecord
  acts_as_paranoid
  belongs_to :client

  validates :client_id, :total, :total_paid, :change, :payment_type, :date, :time, :status, presence: true

  validates :total, :total_paid, :change, :fixed_delivery, numericality: { greater_than_or_equal_to: 0 }

  validates :payment_type, inclusion: { in: %w[Cash CreditCard DebitCard Transfer] }
  validates :status, inclusion: { in: %w[Pending Completed Cancelled] }
  validates :paid, inclusion: { in: %w[Yes No] }, allow_blank: true

  has_many :order_items, dependent: :destroy

  before_destroy :update_order_item_deleted_at, if: :persisted?

  def update_order_item_deleted_at
    order_items.find_each do |order_item|
      order_item.update(deleted_at: Time.current)
    end
  end
end
