require 'rails_helper'

RSpec.describe Manager::Goals::DoneController do
  let!(:user) { create(:user) }
  let!(:client) { create(:client, user: user) }
  let!(:goal) { create(:goal, client: client) }
  let!(:goals) { create_list(:goal, 3, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController).to receive(:authenticate_user!).and_return(true)
  end


  context 'POST #one' do
    it 'status todo to done' do
      post :one, params: { goal_id: goal.id }
      expect(goal.reload.status).to eq('done')

      expect(flash[:notice]).to eq(I18n.t('controllers.manager.goals.done.one'))
    end
  end

  context 'POST #many' do
    it 'status todo to done' do
      post :many, params: { done: { goal_ids: goals.pluck(:id) } }
      expect(goals.first.reload.status).to eq('done')
      expect(flash[:notice]).to eq(I18n.t('controllers.manager.goals.done.other'))
    end
  end
end
