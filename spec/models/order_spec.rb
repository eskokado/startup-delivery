# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  change         :decimal(, )
#  date           :date
#  deleted_at     :datetime
#  fixed_delivery :decimal(, )
#  notes          :text
#  paid           :string
#  payment_type   :string
#  status         :string
#  time           :time
#  total          :decimal(, )
#  total_paid     :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  client_id      :bigint           not null
#  consumer_id    :bigint           not null
#
# Indexes
#
#  index_orders_on_client_id    (client_id)
#  index_orders_on_consumer_id  (consumer_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (consumer_id => consumers.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:order)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:client_id) }
    it { should validate_presence_of(:total) }
    it { should validate_presence_of(:total_paid) }
    it { should validate_presence_of(:change) }
    it { should validate_presence_of(:payment_type) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:time) }
    it { should validate_presence_of(:status) }

    it {
      should validate_numericality_of(:total)
        .is_greater_than_or_equal_to(0)
    }
    it {
      should validate_numericality_of(:total_paid)
        .is_greater_than_or_equal_to(0)
    }
    it {
      should validate_numericality_of(:change)
        .is_greater_than_or_equal_to(0)
    }
    it {
      should validate_numericality_of(:fixed_delivery)
        .is_greater_than_or_equal_to(0)
    }

    it {
      should validate_inclusion_of(:payment_type)
        .in_array(%w[Cash CreditCard DebitCard Transfer])
    }
    it {
      should validate_inclusion_of(:status)
        .in_array(%w[Pending Completed Cancelled])
    }
    it {
      should validate_inclusion_of(:paid)
        .in_array(%w[Yes No]).allow_blank
    }
  end

  describe 'associations' do
    it { should belong_to(:client) }
    it { should belong_to(:consumer) }
  end
end
