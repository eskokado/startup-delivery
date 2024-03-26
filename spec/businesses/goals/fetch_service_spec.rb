require 'rails_helper'

RSpec.describe Goals::FetchService do
  describe '#call' do
    let(:date_1) { 1.day.ago.midnight }
    let(:date_2) { 2.days.ago.midnight }
    let(:date_3) { 3.days.ago.midnight }
    let(:date_4) { 4.days.ago.midnight }
    let(:date_5) { 5.days.ago.midnight }

    let!(:goal_1) { create(:goal, created_at: date_1) }
    let!(:goal_2) { create(:goal, created_at: date_2) }
    let!(:goal_3) { create(:goal, created_at: date_3) }
    let!(:goal_4) { create(:goal, created_at: date_4) }
    let!(:goal_5) { create(:goal, created_at: date_5) }

    context 'when results are ActiveRecord::Relation' do
      it 'orders by created_at DESC and paginates the results' do
        params = { page: 1 }
        service = Goals::FetchService.new(params)
        expect(service.call.to_a).to eq([goal_1, goal_2, goal_3, goal_4])
      end

      context 'when results are an array' do
        it 'sorts by created_at DESC and paginates the results' do
          allow(Goal).to receive(:ransack).and_return(double(result: [goal_5, goal_4, goal_3, goal_2, goal_1]))
          params = { page: 1 }
          service = Goals::FetchService.new(params)
          expect(service.call.to_a).to eq([goal_1, goal_2, goal_3, goal_4])
        end
      end

      context 'with search parameters' do
        it 'filters the results according to the search query' do
          params = { q: { created_at_eq: date_3.to_date.to_s }, page: 1 }
          service = Goals::FetchService.new(params)
          results = service.call.to_a
          expect(results).to eq([goal_3])
        end
      end
    end
  end
end
