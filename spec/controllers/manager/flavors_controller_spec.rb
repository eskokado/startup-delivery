require 'rails_helper'

RSpec.describe Manager::FlavorsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:flavors) { create_list(:flavor, 3, client: client) }
  let(:flavor) { create(:flavor, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @flavors' do
      flavor = FactoryBot.create(:flavor, client: client)
      get :index
      expect(assigns(:flavors)).to eq([flavor])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns @flavors for the given search parameters' do
      double('search_result', result: flavors)
      allow(Flavor)
        .to receive_message_chain(:ransack, :result).and_return(flavors)

      get :index

      expect(assigns(:flavors)).to match_array(flavors)
    end
  end

  describe 'GET #index with search' do
    it 'returns the extras searched correctly' do

      flavor1 = create(:flavor, name: 'Baunilha', client: client)
      flavor2 = create(:flavor, name: 'Chocolate', client: client)
      get :index,
          params: { q: { name_cont: 'baunilha' } }

      expect(assigns(:flavors)).to include(flavor1)
      expect(assigns(:flavors)).to_not include(flavor2)
    end

    it 'excludes non-matching results' do
      create(:flavor, name: 'Non-Matching Extra', client: client)

      get :index,
          params: { q: { name_cont: 'baunilha' } }

      expect(assigns(:flavors)).to be_empty
    end
  end
end
