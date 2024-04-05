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

    it 'assigns @flavors for the given search parameters' do
      double('search_result', result: delivery_locations)
      allow(DeliveryLocation)
        .to receive_message_chain(:ransack, :result)
        .and_return(delivery_locations)

      get :index

      expect(assigns(:delivery_locations)).to match_array(delivery_locations)
    end
  end

  describe 'GET #index with search' do
    it 'returns the extras searched correctly' do
      delivery_location1 = create(
        :delivery_location, name: 'Tal Tal', client: client
      )
      delivery_location2 = create(
        :delivery_location, name: 'Lat Lat', client: client
      )
      get :index,
          params: { q: { name_cont: 'tal' } }

      expect(assigns(:delivery_locations)).to include(delivery_location1)
      expect(assigns(:delivery_locations)).to_not include(delivery_location2)
    end

    it 'excludes non-matching results' do
      create(:delivery_location, name: 'Non-Matching Location', client: client)

      get :index,
          params: { q: { name_cont: 'tal' } }

      expect(assigns(:delivery_locations)).to be_empty
    end

    it 'renders the index template' do
      get :index,
          params: { q: { name_cont: 'Search Nothing' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new DeliveryLocation to @delivery_location' do
      get :new
      expect(assigns(:delivery_location)).to be_a_new(DeliveryLocation)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new delivery_location' do
        expect do
          post :create,
               params: {
                 delivery_location: FactoryBot.attributes_for(
                   :delivery_location, client_id: client.id
                 )
               }
        end.to change(DeliveryLocation, :count).by(1)
      end

      it 'redirects to the delivery_location
          path with a notice on successful save' do
        post :create,
             params: {
               delivery_location: FactoryBot.attributes_for(
                 :delivery_location, client_id: client.id
               )
             }
        expect(response)
          .to redirect_to(
            manager_delivery_location_path(
              assigns(:delivery_location)
            )
          )
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.delivery_locations.create')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new delivery_location' do
        expect do
          post :create, params: {
            delivery_location: FactoryBot.attributes_for(
              :delivery_location,
              name: nil,
              client_id: client.id
            )
          }
        end.not_to change(DeliveryLocation, :count)
      end

      it 're-renders the new method' do
        post :create,
             params: {
               delivery_location: FactoryBot.attributes_for(
                 :delivery_location,
                 name: nil,
                 client_id: client.id
               )
             }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested delivery_location to @delivery_location' do
      get :edit, params: { id: delivery_location.id }
      expect(assigns(:delivery_location)).to eq(delivery_location)
    end

    it 'renders the edit template' do
      get :edit, params: { id: delivery_location.id }
      expect(response).to render_template(:edit)
    end
  end
end
