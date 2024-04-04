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

    it 'renders the index template' do
      get :index,
          params: { q: { name_cont: 'Search Nothing' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Flavor to @flavor' do
      get :new
      expect(assigns(:flavor)).to be_a_new(Flavor)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new flavor' do
        expect do
          post :create,
               params: {
                 flavor: FactoryBot.attributes_for(
                   :flavor, client_id: client.id
                 )
               }
        end.to change(Flavor, :count).by(1)
      end

      it 'redirects to the flavor path with a notice on successful save' do
        post :create,
             params: {
               flavor: FactoryBot.attributes_for(
                 :flavor, client_id: client.id
               )
             }
        expect(response)
          .to redirect_to(manager_flavor_path(assigns(:flavor)))
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.flavors.create')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new flavor' do
        expect do
          post :create, params: {
            flavor: FactoryBot.attributes_for(
              :flavor,
              name: nil,
              client_id: client.id
            )
          }
        end.not_to change(Flavor, :count)
      end

      it 're-renders the new method' do
        post :create,
             params: {
               flavor: FactoryBot.attributes_for(
                 :flavor,
                 name: nil,
                 client_id: client.id
               )
             }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested flavor to @flavor' do
      get :edit, params: { id: flavor.id }
      expect(assigns(:flavor)).to eq(flavor)
    end

    it 'renders the edit template' do
      get :edit, params: { id: flavor.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the flavor' do
        patch :update, params: {
          id: flavor.id,
          flavor: { name: 'Novo sabor', value: 150 }
        }
        flavor.reload
        expect(flavor.name).to eq('Novo sabor')
        expect(flavor.value).to eq(150)
      end

      it 'redirects to the flavor with a notice on successful update' do
        patch :update, params: {
          id: flavor.id,
          flavor: { name: 'Atualizada' }
        }
        expect(response).to redirect_to(manager_flavor_path(flavor))
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.flavors.update')
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: flavor.id }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested flavor to @flavor' do
      expect(assigns(:flavor)).to eq(flavor)
    end
  end

  describe 'DELETE #destroy' do
    let!(:flavor) { create(:flavor, client: client) }

    it 'deletes the flavor' do
      expect do
        delete :destroy, params: { id: flavor.id }
      end.to change(Flavor, :count).by(-1)
    end

    it 'redirects to the flavor index with a notice' do
      delete :destroy, params: { id: flavor.id }
      expect(response).to redirect_to(manager_flavors_path)
      expect(flash[:notice])
        .to eq(I18n.t('controllers.manager.flavors.destroy'))
    end
  end
end
