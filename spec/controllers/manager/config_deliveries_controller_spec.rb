require 'rails_helper'

RSpec.describe Manager::ConfigDeliveriesController,
               type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:client) { FactoryBot.create(:client, user: user) }
  let(:config_delivery) { FactoryBot.create(:config_delivery, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #edit_config' do
    it 'assigns the requested config_delivery to @config_delivery' do
      config_delivery.save!
      get :edit_config
      expect(assigns(:config_delivery)).to eq(config_delivery)
    end

    it 'renders the index template' do
      get :edit_config
      expect(response).to render_template(:edit_config)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the config_delivery' do
        patch :update_config, params: {
          config_delivery: {
            delivery_forecast: 30,
            delivery_fee: 6,
            opening_time: '08:00',
            closing_time: '23:59'
          }
        }
        config_delivery.reload
        expect(config_delivery.delivery_forecast).to eq(30)
        expect(config_delivery.delivery_fee).to eq(6)
        expect(config_delivery.opening_time.strftime('%H:%M')).to eq('08:00')
        expect(config_delivery.closing_time.strftime('%H:%M')).to eq('23:59')
      end
    end
  end
end
