require 'rails_helper'

RSpec.describe Manager::ProductsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    before do
      create_list(:product, 10)
      get :index
    end

    it 'populates an array of products' do
      expect(assigns(:products)).to match_array(Product.all)
    end
  end
end
