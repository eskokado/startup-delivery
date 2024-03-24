require 'rails_helper'

RSpec.describe Api::Goals::DoneController, type: :request do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:auth_headers) { auth_user(user) }

  describe 'POST /api/goals/done/index' do
    let(:client) { create(:client, user: user) }

    before do
      @goal = create(:goal, :with_tasks, client: client)
    end

    it 'marks a goal as done' do
      post '/api/goals/done/index', params: { goal_id: @goal.id }, headers: auth_headers
      expect(response).to have_http_status(:ok)

      data = json_response
      expect(data['status']).to eq('done')
      expect(response).to match_response_schema('goal')
    end

    it 'returns 404 if goal is not found' do
      post '/api/goals/done/index', params: { goal_id: 'invalid' }, headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/goals/done/show' do
    let(:client) { create(:client, user: user) }

    before do
      @goal = create(:goal, :with_tasks, client: client)
    end

    it 'marks a goal as done' do
      post '/api/goals/done/show', params: { goal_id: @goal.id }, headers: auth_headers

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)
      expect(data['status']).to eq('done')
      expect(response).to match_response_schema('goal')
    end

    it 'returns 404 if goal is not found' do
      post '/api/goals/done/show', params: { goal_id: 'invalid' }, headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/goals/done/many' do
    let(:client) { create(:client, user: user) }

    before do
      @goals = create_list(:goal, 3, :with_tasks, client: client)
    end

    it 'marks goals as done' do
      post '/api/goals/done/many', params: { goal_ids: @goals.pluck(:id) }, headers: auth_headers

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)
      expect(data[1]['status']).to eq('done')
      expect(response).to match_response_schema('goals')
    end

    it 'returns 404 if goals are not found' do
      post '/api/goals/done/many', params: { goal_ids: 'invalid' }, headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
