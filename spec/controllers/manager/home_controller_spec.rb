require 'rails_helper'

RSpec.describe Manager::HomeController, type: :controller do
  describe "GET #index" do
    before do
      # Setup test data
      create_list(:client, 10)
      create_list(:order, 5, date: Time.zone.today, status: 'Completed')
      create_list(:order, 3, date: Time.zone.today, status: 'Waiting')
      create(:order, date: 1.day.ago, status: 'Completed') # Not to be counted for today
      create(:order, date: Time.zone.today, status: 'Completed', total: 100)
    end

    it "assigns @total_clients" do
      get :index
      expect(assigns(:total_clients)).to eq(10)
    end

    it "assigns @total_orders_day" do
      get :index
      expect(assigns(:total_orders_day)).to eq(8) # 5 Completed + 3 Waiting
    end

    it "assigns @total_orders_waiting" do
      get :index
      expect(assigns(:total_orders_waiting)).to eq(3)
    end

    it "assigns @total_sold" do
      get :index
      expect(assigns(:total_sold)).to eq(500) # Assuming each order has a default total of 100
    end
  end
end
