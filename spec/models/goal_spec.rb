# == Schema Information
#
# Table name: goals
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  finished_at :datetime
#  name        :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer
#
# Indexes
#
#  index_goals_on_deleted_at  (deleted_at)
#
require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
    it { should belong_to(:client) }
  end

  describe 'custom methods' do
    let(:client) { create(:client) }
    let(:goal) { create(:goal, client: client) }

    it "soft deletes associated tasks when goal is destroyed" do
      task = create(:task, goal: goal)
      goal.destroy
      expect(task.reload.deleted_at).not_to be_nil
    end

    it "marks goal as done" do
      goal.done!
      expect(goal.status).to eq("done")
    end
  end
end
