require 'rails_helper'

RSpec.describe Manager::HomeController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @total_clients' do
      create_list(:client, 10)
      get :index
      expect(assigns(:total_clients)).to eq(10)
    end

    it 'assigns @total_orders_day' do
      create_list(:order, 5, date: Time.zone.today, status: 'Completed')
      create_list(:order, 3, date: Time.zone.today, status: 'Waiting')
      create(:order, date: 1.day.ago, status: 'Completed')
      get :index
      expect(assigns(:total_orders_day)).to eq(8)
    end

    it 'assigns @total_orders_waiting' do
      create_list(:order, 3, date: Time.zone.today, status: 'Waiting')
      get :index
      expect(assigns(:total_orders_waiting)).to eq(3)
    end

    it 'assigns @total_sold' do
      create(:order, date: Time.zone.today, status: 'Completed', total: 100)
      get :index
      expect(assigns(:total_sold)).to eq(100)
    end
  end
end
