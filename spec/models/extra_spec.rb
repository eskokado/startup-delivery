# == Schema Information
#
# Table name: extras
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  name        :string
#  value       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  client_id   :bigint           not null
#
# Indexes
#
#  index_extras_on_category_id  (category_id)
#  index_extras_on_client_id    (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe Extra, type: :model do
  it 'is valid with valid attributes' do
    extra = FactoryBot.create(:extra)
    expect(extra).to be_valid
  end

  it 'is not valid without a name' do
    extra = build(:extra, name: nil)
    expect(extra).not_to be_valid
  end

  it 'is not valid without a value' do
    extra = build(:extra, value: nil)
    expect(extra).not_to be_valid
  end

  it 'is not valid with a value less than or equal to 0' do
    extra = build(:extra, value: 0)
    expect(extra).not_to be_valid
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:client) }
  end
end
