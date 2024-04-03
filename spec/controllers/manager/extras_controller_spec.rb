require 'rails_helper'

RSpec.describe Manager::ExtrasController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }
  let(:category) { create(:category, client: client) }

  let(:extras) { create_list(:extra, 3, client: client) }
  let(:extra) { create(:extra, client: client, category: category) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @extras' do
      extra = FactoryBot.create(:extra, client: client)
      get :index
      expect(assigns(:extras)).to eq([extra])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns @extras for the given search parameters' do
      double('search_result', result: extras)
      allow(Extra)
        .to receive_message_chain(:ransack, :result).and_return(extras)

      get :index

      expect(assigns(:extras)).to match_array(extras)
    end
  end

  describe 'GET #index with search' do
    it 'returns the extras searched correctly' do
      extra1 = create(:extra, name: 'Fritas grandes', client: client)
      extra2 = create(:extra, name: 'Fritas completo', client: client)
      get :index,
          params: { q: { name_cont: 'grandes' } }

      expect(assigns(:extras)).to include(extra1)
      expect(assigns(:extras)).to_not include(extra2)
    end

    it 'excludes non-matching results' do
      create(:extra, name: 'Non-Matching Extra', client: client)

      get :index,
          params: { q: { name_cont: 'Pequeno' } }

      expect(assigns(:extras)).to be_empty
    end
  end
end
