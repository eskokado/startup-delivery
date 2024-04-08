# == Schema Information
#
# Table name: consumers
#
#  id         :bigint           not null, primary key
#  city       :string
#  complement :string
#  deleted_at :datetime
#  district   :string
#  document   :string
#  email      :string
#  name       :string
#  number     :string
#  phone      :string
#  state      :string
#  street     :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_consumers_on_deleted_at  (deleted_at)
#  index_consumers_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Consumer, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:document) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:orders).dependent(:destroy) }
  end
end
