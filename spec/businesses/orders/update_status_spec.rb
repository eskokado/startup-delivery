RSpec.describe Orders::UpdateStatus do
  describe '#call' do
    let(:user) { FactoryBot.create(:user) }
    let(:client) { FactoryBot.create(:client, user: user) }

    context 'when the current status is "Waiting"' do
      let(:order) { create(:order, client: client, status: 'Waiting') }
      it 'updates the order status to "Started"' do
        business = described_class.new(order)
        business.call

        expect(order.reload.status).to eq('Started')
      end
    end

    context 'when the current status is "Started"' do
      let(:order) { create(:order, client: client, status: 'Started') }

      it 'updates the order status to "Prepared"' do
        business = described_class.new(order)
        business.call

        expect(order.reload.status).to eq('Prepared')
      end
    end

    context 'when the current status is "Prepared"' do
      let(:order) { create(:order, client: client, status: 'Prepared') }

      it 'updates the order status to "Dispatched"' do
        business = described_class.new(order)
        business.call

        expect(order.reload.status).to eq('Dispatched')
      end
    end

    context 'when the current status is "Dispatched"' do
      let(:order) { create(:order, client: client, status: 'Dispatched') }

      it 'updates the order status to "Completed"' do
        business = described_class.new(order)
        business.call

        expect(order.reload.status).to eq('Completed')
      end
    end

    context 'when the current status is Canceled' do
      let(:order) { create(:order, client: client, status: 'Canceled') }

      it 'does not update the order status' do
        business = described_class.new(order)
        business.call

        expect(order.reload.status).to eq('Canceled')
      end
    end
  end
end
