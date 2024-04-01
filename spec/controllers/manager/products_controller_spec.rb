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
end
