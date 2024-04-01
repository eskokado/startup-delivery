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
  end
end
