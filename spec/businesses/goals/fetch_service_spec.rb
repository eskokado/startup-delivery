require 'rails_helper'

RSpec.describe Goals::FetchService do
  describe '#call' do
    let(:one_day_ago) { 1.day.ago.midnight }
    let(:two_days_ago) { 2.days.ago.midnight }
    let(:three_days_ago) { 3.days.ago.midnight }
    let(:four_days_ago) { 4.days.ago.midnight }
    let(:five_days_ago) { 5.days.ago.midnight }

    let!(:goal_recent) { create(:goal, created_at: one_day_ago) }
    let!(:goal_two_days_ago) { create(:goal, created_at: two_days_ago) }
    let!(:goal_three_days_ago) { create(:goal, created_at: three_days_ago) }
    let!(:goal_four_days_ago) { create(:goal, created_at: four_days_ago) }
    let!(:goal_oldest) { create(:goal, created_at: five_days_ago) }

    context 'when results are ActiveRecord::Relation' do
      it 'orders by created_at DESC and paginates the results' do
        params = { page: 1 }
        service = Goals::FetchService.new(params)
        expect(service.call.to_a).to eq([goal_recent,
                                         goal_two_days_ago,
                                         goal_three_days_ago,
                                         goal_four_days_ago])
      end

      context 'when results are an array' do
        it 'sorts by created_at DESC and paginates the results' do
          allow(Goal).to receive(:ransack).and_return(
            double(result: [goal_oldest,
                            goal_four_days_ago,
                            goal_three_days_ago,
                            goal_two_days_ago,
                            goal_recent])
          )
          params = { page: 1 }
          service = Goals::FetchService.new(params)
          expect(service.call.to_a).to eq([
                                            goal_recent,
                                            goal_two_days_ago,
                                            goal_three_days_ago,
                                            goal_four_days_ago
                                          ])
        end
      end

      context 'with search parameters' do
        it 'filters the results according to the search query' do
          params = {
            q: { created_at_eq: three_days_ago.to_date.to_s },
            page: 1
          }

          service = Goals::FetchService.new(params)
          results = service.call.to_a
          expect(results).to eq([goal_three_days_ago])
        end
      end
    end
  end
end
