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

    it 'renders the index template' do
      get :index,
          params: { q: { name_cont: 'Search Nothing' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Clerk to @clerk' do
      get :new
      expect(assigns(:clerk)).to be_a_new(Clerk)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new clerk' do
        expect do
          post :create,
               params: {
                 clerk: FactoryBot.attributes_for(
                   :clerk, client_id: client.id
                 )
               }
        end.to change(Clerk, :count).by(1)
      end

      it 'redirects to the clerk path with a notice on successful save' do
        post :create,
             params: {
               clerk: FactoryBot.attributes_for(
                 :clerk, client_id: client.id
               )
             }
        expect(response)
          .to redirect_to(manager_clerk_path(assigns(:clerk)))
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.clerks.create')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new clerk' do
        expect do
          post :create, params: {
            clerk: FactoryBot.attributes_for(
              :clerk,
              name: nil,
              client_id: client.id
            )
          }
        end.not_to change(Clerk, :count)
      end

      it 're-renders the new method' do
        post :create,
             params: {
               clerk: FactoryBot.attributes_for(
                 :clerk,
                 name: nil,
                 client_id: client.id
               )
             }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested clerk to @clerk' do
      get :edit, params: { id: clerk.id }
      expect(assigns(:clerk)).to eq(clerk)
    end

    it 'renders the edit template' do
      get :edit, params: { id: clerk.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the clerk' do
        patch :update, params: {
          id: clerk.id,
          clerk: { name: 'Novo name' }
        }
        clerk.reload
        expect(clerk.name).to eq('Novo name')
      end
    end
  end
end
