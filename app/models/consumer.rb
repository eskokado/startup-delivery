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
class Consumer < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  has_many :orders, dependent: :destroy

  before_destroy :update_order_deleted_at, if: :persisted?

  validates :document, presence: true

  def update_order_deleted_at
    orders.find_each do |order|
      order.update(deleted_at: Time.current)
    end
  end
end
