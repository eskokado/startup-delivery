# == Schema Information
#
# Table name: extras
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  name        :string
#  value       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  client_id   :bigint           not null
#
# Indexes
#
#  index_extras_on_category_id  (category_id)
#  index_extras_on_client_id    (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :extra do
    name { FFaker::Product.product_name }
    value { FFaker::Number.decimal(whole_digits: 2, fractional_digits: 2) }
    association :category, factory: :category
    association :client, factory: :client
    deleted_at { nil }
  end
end
