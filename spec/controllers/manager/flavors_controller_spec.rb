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
  end
end
