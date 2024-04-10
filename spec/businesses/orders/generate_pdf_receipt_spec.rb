require 'prawn'

RSpec.describe Orders::GeneratePdfReceipt do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }
  let(:order) { create(:order, client: client) }

  subject { described_class.new(order) }

  describe '#call' do
    it 'generates a PDF receipt' do
      expect(subject.call).to be_a(Prawn::Document)
    end
  end
end
