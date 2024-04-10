require 'rails_helper'

RSpec.describe Orders::Destroy, type: :business do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { FactoryBot.create(:client, user: user) }

  let(:order) { create(:order, client: client, status: 'Waiting') }
  let(:business) { described_class.new(order) }

  describe '#call' do
    context 'when the order status is "Waiting"' do
      it 'destroys the order and returns true' do
        expect(order).to receive(:destroy)
        result = business.call
        expect(result).to be true
      end
    end

    context 'when the order status is not "Waiting"' do
      it 'does not destroy the order and returns false' do
        order.update(status: 'Dispatched')
        expect(order).not_to receive(:destroy)
        result = business.call
        expect(result).to be false
      end
    end
  end
end
