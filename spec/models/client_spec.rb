# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  document   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_clients_on_deleted_at  (deleted_at)
#  index_clients_on_user_id     (user_id)
#
require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:goals).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:document) }
  end
  describe 'Custom methods' do
    let(:user) { create(:user) }
    let(:client) { create(:client, user: user) }

    it 'soft deletes associated goals when client is destroyed' do
      goal = create(:goal, client: client)
      client.destroy
      expect(goal.reload.deleted_at).not_to be_nil
    end
  end
end
