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
class Category < ApplicationRecord
  has_one_attached :image

  acts_as_paranoid
  belongs_to :client

  validates :name, presence: true
  validates :description, presence: true
end
