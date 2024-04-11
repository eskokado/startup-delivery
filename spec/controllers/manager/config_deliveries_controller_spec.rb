require 'rails_helper'

RSpec.describe Manager::ConfigDeliveriesController,
               type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    @client = FactoryBot.create(:client, user: user)
    @config_delivery = FactoryBot.create(:config_delivery, client: @client)
  end

  describe 'GET #edit_config' do
    it 'assigns the requested config_delivery to @config_delivery' do
      @config_delivery.save!
      get :edit_config
      expect(assigns(:config_delivery)).to eq(@config_delivery)
    end

    it 'renders the index template' do
      get :edit_config
      expect(response).to render_template(:edit_config)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:config_delivery_attributes) do
        FactoryBot.attributes_for(:config_delivery)
      end

      it 'updates the config_delivery' do
        patch :update_config, params: {
          config_delivery: config_delivery_attributes.merge(
            delivery_forecast: 40,
            delivery_fee: 10,
            opening_time: Time.zone.parse('12:00:00').strftime('%H:%M'),
            closing_time: Time.zone.parse('22:59:00').strftime('%H:%M')
          )
        }
        @config_delivery.reload
        expect(@config_delivery.delivery_forecast).to eq(40)
        expect(@config_delivery.delivery_fee).to eq(10)
        expect(@config_delivery.opening_time.strftime('%H:%M')).to eq('12:00')
        expect(@config_delivery.closing_time.strftime('%H:%M')).to eq('22:59')
        expect(response).to redirect_to(manager_edit_config_path)
        expect(flash[:notice])
          .to eq I18n.t('controllers.manager.config_deliveries.update')
      end
    end
  end
end
