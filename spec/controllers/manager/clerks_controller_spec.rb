require 'rails_helper'

RSpec.describe Manager::ClerksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:clerks) { create_list(:clerk, 3, client: client) }
  let(:clerk) { create(:clerk, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @clerks' do
      clerk = FactoryBot.create(:clerk, client: client)
      get :index
      expect(assigns(:clerks)).to eq([clerk])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns @clerks for the given search parameters' do
      double('search_result', result: clerks)
      allow(Clerk)
        .to receive_message_chain(:ransack, :result).and_return(clerks)

      get :index

      expect(assigns(:clerks)).to match_array(clerks)
    end
  end

  describe 'GET #index with search' do
    it 'returns the extras searched correctly' do
      clerk1 = create(:clerk, name: 'Erica Silva', client: client)
      clerk2 = create(:clerk, name: 'Marcos Souza', client: client)
      get :index,
          params: { q: { name_cont: 'silva' } }

      expect(assigns(:clerks)).to include(clerk1)
      expect(assigns(:clerks)).to_not include(clerk2)
    end

    it 'excludes non-matching results' do
      create(:clerk, name: 'Non-Matching clerk', client: client)

      get :index,
          params: { q: { name_cont: 'silva' } }

      expect(assigns(:clerks)).to be_empty
    end
  end
end