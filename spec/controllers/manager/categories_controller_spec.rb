require 'rails_helper'

RSpec.describe Manager::CategoriesController,
               type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }
  let(:category) { create(:category, client: client) }

  let(:categories) { create_list(:category, 3, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @categories' do
      category = FactoryBot.create(:category, client: client)
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @categories for the given search parameters' do
      double('search_result', result: categories)
      allow(Category)
        .to receive_message_chain(:ransack, :result).and_return(categories)

      get :index

      expect(assigns(:categories)).to match_array(categories)
    end
  end

  describe 'GET #index with search' do
    it 'returns the categories searched correctly' do
      category1 = create(:category,
                         name: 'Pizzas',
                         description: 'Pizzas grandes',
                         client: client)
      category2 = create(:category,
                         name: 'Lanches',
                         description: 'Combobox completo',
                         client: client)
      get :index,
          params: { q: { name_or_description_cont: 'grandes' } }

      expect(assigns(:categories)).to include(category1)
      expect(assigns(:categories)).to_not include(category2)
    end

    it 'excludes non-matching results' do
      create(:category, name: 'Non-Matching Category', client: client)

      get :index,
          params: { q: { name_or_description_cont: 'Pequeno' } }

      expect(assigns(:categories)).to be_empty
    end

    it 'renders the index template' do
      get :index,
          params: { q: { name_or_description_cont: 'Search Nothing' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Category to @category' do
      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new category' do
        expect do
          post :create,
               params: {
                 category: FactoryBot.attributes_for(
                   :category, client_id: client.id
                 )
               }
        end.to change(Category, :count).by(1)
      end

      it 'redirects to the category path with a notice on successful save' do
        post :create,
             params: {
               category: FactoryBot.attributes_for(
                 :category, client_id: client.id
               )
             }
        expect(response)
          .to redirect_to(manager_category_path(assigns(:category)))
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.categories.create')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new category' do
        expect do
          post :create, params: {
            category: FactoryBot.attributes_for(
              :category,
              name: nil,
              client_id: client.id
            )
          }
        end.not_to change(Category, :count)
      end

      it 're-renders the new method' do
        post :create,
             params: {
               category: FactoryBot.attributes_for(
                 :category, name: nil, client_id: client.id
               )
             }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested category to @category' do
      get :edit, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
    end
  end
end
