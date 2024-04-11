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
end
