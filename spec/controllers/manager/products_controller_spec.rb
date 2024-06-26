require 'rails_helper'

RSpec.describe Manager::ProductsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }
  let(:category) { create(:category, client: client) }

  let(:products) { create_list(:product, 10, client: client) }
  let(:product) { create(:product, client: client, category: category) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    paginated_products = Kaminari.paginate_array(products).page(1).per(4)
    fetch_double = instance_double(
      'Products::Fetch',
      call: paginated_products, search: products
    )
    allow(Products::Fetch).to receive(:new).and_return(fetch_double)
  end

  describe 'GET #index' do
    before do
      get :index
    end

    it 'populates an array of products with the default per_page value' do
      expect(assigns(:products).size).to eq(4)
    end

    it 'renders the :index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns a new Product to @product' do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new product' do
        expect do
          post :create,
               params: {
                 product: FactoryBot.attributes_for(
                   :product, client_id: client.id, category_id: category.id
                 )
               }
        end.to change(Product, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new product' do
        expect do
          post :create, params: {
            product: FactoryBot.attributes_for(
              :product,
              name: nil,
              client_id: client.id
            )
          }
        end.not_to change(Product, :count)
      end

      it 're-renders the new method' do
        post :create,
             params: {
               product: FactoryBot.attributes_for(
                 :product, name: nil, client_id: client.id
               )
             }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested product to @product' do
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end

    it 'renders the edit template' do
      get :edit, params: { id: product.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the product' do
        patch :update, params: {
          id: product.id,
          product: { name: 'Novo produto', description: 'Nova descrição' }
        }
        product.reload
        expect(product.name).to eq('Novo produto')
        expect(product.description).to eq('Nova descrição')
      end

      it 'redirects to the product with a notice on successful update' do
        patch :update, params: {
          id: product.id,
          product: { name: 'Atualizada' }
        }
        expect(response).to redirect_to(manager_product_path(product))
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.products.update')
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: product.id }
    end

    it 'responds with success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested product to @product' do
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { create(:product, client: client) }

    it 'deletes the product' do
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)
    end

    it 'redirects to the products index with a notice' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(manager_products_path)
      expect(flash[:notice])
        .to eq(I18n.t('controllers.manager.products.destroy'))
    end
  end
end
