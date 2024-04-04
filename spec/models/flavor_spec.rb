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
require 'rails_helper'

RSpec.describe Flavor, type: :model do
  it 'is valid with valid attributes' do
    flavor = FactoryBot.create(:extra)
    expect(flavor).to be_valid
  end

  it 'is not valid without a name' do
    flavor = build(:flavor, name: nil)
    expect(flavor).not_to be_valid
  end

  it 'is not valid without a value' do
    flavor = build(:flavor, value: nil)
    expect(flavor).not_to be_valid
  end
end
