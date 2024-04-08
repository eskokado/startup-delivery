# == Schema Information
#
# Table name: consumers
#
#  id         :bigint           not null, primary key
#  city       :string
#  complement :string
#  deleted_at :datetime
#  district   :string
#  document   :string
#  email      :string
#  name       :string
#  number     :string
#  phone      :string
#  state      :string
#  street     :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_consumers_on_deleted_at  (deleted_at)
#  index_consumers_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :consumer do
    name { FFaker::NameBR.name }
    document { FFaker::IdentificationBR.cpf }
    phone { FFaker::PhoneNumber.phone_number }
    street { FFaker::AddressBR.street }
    number { FFaker::AddressBR.building_number }
    district { FFaker::AddressBR.neighborhood }
    city { FFaker::AddressBR.city }
    state { FFaker::AddressBR.state_abbr }
    zipcode { FFaker::AddressBR.zip_code }
    complement { FFaker::AddressBR.secondary_address }
    association :user, factory: :user
  end
end
