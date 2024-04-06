# == Schema Information
#
# Table name: clerks
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  document   :string
#  name       :string
#  person     :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_clerks_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
require 'rails_helper'

RSpec.describe Clerk, type: :model do
  it 'is valid with valid attributes' do
    clerk = FactoryBot.create(:clerk)
    expect(clerk).to be_valid
  end

  it 'is not valid without a name' do
    clerk = build(:clerk, name: nil)
    expect(clerk).not_to be_valid
  end

  it 'is not valid without a document' do
    clerk = build(:clerk, document: nil)
    expect(clerk).not_to be_valid
  end
end
