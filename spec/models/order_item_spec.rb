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
require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:order_item)).to be_valid
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:document) }
  end

  describe "associations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end
end
