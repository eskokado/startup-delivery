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
class Extra < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  belongs_to :client

  validates :name, :value, presence: true
  validates :value, numericality: { greater_than: 0 }
  validates :category_id, presence: true
end
