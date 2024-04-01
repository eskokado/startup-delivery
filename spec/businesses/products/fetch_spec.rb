require 'rails_helper'

RSpec.describe Products::Fetch do
  describe '#call' do
    let(:user) { FactoryBot.create(:user) }
    let(:client) { create(:client, user: user) }

    let(:one_day_ago) { 1.day.ago.midnight }
    let(:two_days_ago) { 2.days.ago.midnight }
    let(:three_days_ago) { 3.days.ago.midnight }
    let(:four_days_ago) { 4.days.ago.midnight }
    let(:five_days_ago) { 5.days.ago.midnight }

    let!(:product_recent) do
      create(
        :product,
        created_at: one_day_ago,
        client: client
      )
    end
    let!(:product_two_days_ago) do
      create(:product, created_at: two_days_ago, client: client)
    end
    let!(:product_three_days_ago) do
      create(:product, created_at: three_days_ago, client: client)
    end
    let!(:product_four_days_ago) do
      create(:product, created_at: four_days_ago, client: client)
    end
    let!(:product_oldest) do
      create(:product, created_at: five_days_ago, client: client)
    end

    context 'when results are ActiveRecord::Relation' do
      it 'orders by created_at DESC and paginates the results' do
        params = { page: 1 }
        service = Products::Fetch.new(params, client: client)
        expect(service.call.to_a).to eq([product_recent,
                                         product_two_days_ago,
                                         product_three_days_ago,
                                         product_four_days_ago])
      end
    end

    context 'when results are an array' do
      it 'sorts by created_at DESC and paginates the results' do
        allow(Product).to receive(:ransack).and_return(
          double(result: [product_oldest,
                          product_four_days_ago,
                          product_three_days_ago,
                          product_two_days_ago,
                          product_recent])
        )
        params = { page: 1 }
        service = Products::Fetch.new(params, client: client)
        expect(service.call.to_a).to eq([
                                          product_recent,
                                          product_two_days_ago,
                                          product_three_days_ago,
                                          product_four_days_ago
                                        ])
      end
    end

    context 'with search parameters' do
      it 'filters the results according to the search query' do
        params = {
          q: { created_at_eq: three_days_ago.to_date.to_s },
          page: 1
        }

        service = Products::Fetch.new(params, client: client)
        results = service.call.to_a
        expect(results).to eq([product_three_days_ago])
      end
    end
  end
end
