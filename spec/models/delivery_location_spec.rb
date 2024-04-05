# == Schema Information
#
# Table name: delivery_locations
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
#  index_delivery_locations_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe DeliveryLocation, type: :model do
  it 'is valid with valid attributes' do
    delivery_location = FactoryBot.create(:delivery_location)
    expect(delivery_location).to be_valid
  end
end
