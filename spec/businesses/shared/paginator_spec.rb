require 'rails_helper'

RSpec.describe Shared::Paginator do
  let(:page) { 1 }
  let(:per_page) { 2 }

  describe '#call' do
    context 'when results is an ActiveRecord::Relation' do
      before do
        create_list(:user, 5)
      end

      it 'orders and paginates the relation' do
        results = User.all
        paginator = Shared::Paginator.new(results, page, per_page)
        paginated_results = paginator.call

        expect(paginated_results).to respond_to(:total_pages)
        expect(paginated_results.size).to eq(per_page)
      end
    end

    context 'when results is an Array' do
      let(:results) do
        [
          OpenStruct.new(created_at: 3.days.ago),
          OpenStruct.new(created_at: 2.days.ago),
          OpenStruct.new(created_at: 1.day.ago),
          OpenStruct.new(created_at: Time.zone.now)
        ]
      end

      it 'sorts and paginates the array' do
        paginator = Shared::Paginator.new(results, page, per_page)
        paginated_results = paginator.call

        expect(paginated_results.size).to eq(2)
        expect(paginated_results.first.created_at)
          .to be > paginated_results.last.created_at
        expect(paginated_results).to be_a(Kaminari::PaginatableArray)
        expect(paginated_results).to respond_to(:total_pages)
      end
    end
  end
end
