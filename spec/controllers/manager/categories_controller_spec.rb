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
  end
end
