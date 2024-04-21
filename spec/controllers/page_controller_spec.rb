require 'rails_helper'

RSpec.describe PageController, type: :controller do
  describe 'GET actions with admin layout' do
    %i[integrations team billing notifications settings activity profile
       people calendar assignments message messages project projects
       dashboard].each do |action|
      it "renders #{action} with admin layout" do
        get action
        expect(response).to render_template(layout: 'admin')
      end
    end
  end

  describe 'GET pricing' do
    it 'renders pricing without admin layout' do
      get :pricing
      expect(response).to_not render_template(layout: 'admin')
    end
  end

  describe 'GET about' do
    it 'renders about without admin layout' do
      get :about
      expect(response).to_not render_template(layout: 'admin')
    end
  end
end
