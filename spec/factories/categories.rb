# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :text
#  image_url   :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :bigint           not null
#
# Indexes
#
#  index_categories_on_client_id   (client_id)
#  index_categories_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :category do
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    image_url { FFaker::Image.url }
    association :client, factory: :client
    deleted_at { nil }
  end
end
