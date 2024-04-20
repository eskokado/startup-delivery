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
require 'rails_helper'

RSpec.describe ConfigDelivery, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:config_delivery)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:opening_time) }
    it { should validate_presence_of(:closing_time) }

    it {
      should validate_numericality_of(:delivery_forecast).is_greater_than(0)
    }
    it {
      should validate_numericality_of(:delivery_fee).is_greater_than(0)
    }
  end

  describe 'associations' do
    it { should belong_to(:client) }
  end
end
