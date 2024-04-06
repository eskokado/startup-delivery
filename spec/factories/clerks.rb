# == Schema Information
#
# Table name: clerks
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  document   :string
#  name       :string
#  person     :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_clerks_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :clerk do
    name { FFaker::NameBR.name }
    document { FFaker::Number.number(digits: 11) }
    phone { FFaker::PhoneNumberBR.phone_number }
    person { 'root' }
    association :client, factory: :client
    deleted_at { nil }
  end
end
