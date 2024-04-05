require 'rails_helper'

RSpec.describe Manager::DeliveryLocationsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:delivery_locations) do
    create_list(:delivery_location, 3, client: client)
  end
  let(:delivery_location) { create(:delivery_location, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @delivery_locations' do
      delivery_location = FactoryBot.create(:delivery_location, client: client)
      get :index
      expect(assigns(:delivery_locations)).to eq([delivery_location])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
