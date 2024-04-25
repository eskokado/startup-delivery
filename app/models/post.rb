# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  deleted_at :datetime
#  image_url  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_posts_on_client_id   (client_id)
#  index_posts_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Post < ApplicationRecord
  acts_as_paranoid

  has_one_attached :image

  belongs_to :client

  validates :title, :content, presence: true
end
