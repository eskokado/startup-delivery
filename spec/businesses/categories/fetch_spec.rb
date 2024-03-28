require 'rails_helper'

RSpec.describe Categories::Fetch do
  describe '#call' do
    let(:user) { FactoryBot.create(:user) }
    let(:client) { create(:client, user: user) }

    let(:one_day_ago) { 1.day.ago.midnight }
    let(:two_days_ago) { 2.days.ago.midnight }
    let(:three_days_ago) { 3.days.ago.midnight }
    let(:four_days_ago) { 4.days.ago.midnight }
    let(:five_days_ago) { 5.days.ago.midnight }

    let!(:category_recent) {
      create(:category, created_at: one_day_ago, client: client)
    }
    let!(:category_two_days_ago) {
      create(:category, created_at: two_days_ago, client: client)
    }
    let!(:category_three_days_ago) {
      create(:category, created_at: three_days_ago, client: client)
    }
    let!(:category_four_days_ago) {
      create(:category, created_at: four_days_ago, client: client)
    }
    let!(:category_oldest) {
      create(:category, created_at: five_days_ago, client: client)
    }

    context 'when results are ActiveRecord::Relation' do
      it 'orders by created_at DESC and paginates the results' do
        params = { page: 1 }
        service = Categories::Fetch.new(params, client: client)
        expect(service.call.to_a).to eq([category_recent,
                                         category_two_days_ago,
                                         category_three_days_ago,
                                         category_four_days_ago])
      end
    end
  end
end
