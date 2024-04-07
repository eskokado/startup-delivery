require 'rails_helper'

RSpec.describe Manager::OrdersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:orders) { create_list(:order, 3, client: client) }
  let(:order) { create(:order, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @orders' do
      order = FactoryBot.create(:order, client: client)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end
end
