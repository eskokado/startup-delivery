require 'rails_helper'

RSpec.describe Manager::Goals::DoneController,
               type: :controller do
  let(:goal) { create(:goal) }
  let(:goals) { create_list(:goal, 3) }

  before do
    user = FactoryBot.create(:user) # Crie um usuário válido para autenticar
    sign_in user # Faça o login do usuário criado
  end

  context 'POST #index' do
    it 'status todo to done' do
      expect do
        post :index,
             params: { goal_id: goal.id }
      end.to change { goal.reload.status }.from('todo').to('done')
      expect(flash[:notice]).to eq(I18n.t('controllers.manager.goals.done.one'))
    end
  end

  context 'POST #show' do
    it 'status todo to done' do
      expect do
        post :show,
             params: { goal_id: goal.id }
      end.to change { goal.reload.status }.from('todo').to('done')
      expect(flash[:notice]).to eq(I18n.t('controllers.manager.goals.done.one'))
    end
  end

  context 'POST #many' do
    it 'status todo to done' do
      expect do
        post :many,
             params: { goal_ids: goals.pluck(:id) }, as: :json
      end.to change { goals.first.reload.status }.from('todo').to('done')
      expect(JSON.parse(response.body)['message'])
        .to(eq(I18n.t('controllers.manager.goals.done.other')))
    end
  end
end
