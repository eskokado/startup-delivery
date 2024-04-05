# == Schema Information
#
# Table name: flavors
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_flavors_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Flavor < ApplicationRecord
  acts_as_paranoid

  belongs_to :client

  validates :name, :value, presence: true
  validates :value, numericality: { greater_than: 0 }
end
