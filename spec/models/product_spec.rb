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
require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'is valid with valid attributes' do
    product = build(:product)
    expect(product).to be_valid
  end

  it 'is not valid without a name' do
    product = build(:product, name: nil)
    expect(product).not_to be_valid
  end
end
