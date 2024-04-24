# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  document   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_clients_on_deleted_at  (deleted_at)
#  index_clients_on_user_id     (user_id)
#
class Client < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :goals, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :extras, dependent: :destroy
  has_many :flavors, dependent: :destroy
  has_many :delivery_locations, dependent: :destroy
  has_many :clerks, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :document, presence: true

  before_destroy :update_goals_deleted_at, if: :persisted?
  before_destroy :update_categories_deleted_at, if: :persisted?
  before_destroy :update_products_deleted_at, if: :persisted?
  before_destroy :update_extras_deleted_at, if: :persisted?
  before_destroy :update_flavors_deleted_at, if: :persisted?
  before_destroy :update_delivery_locations_deleted_at, if: :persisted?
  before_destroy :update_clerk_deleted_at, if: :persisted?
  before_destroy :update_order_deleted_at, if: :persisted?
  before_destroy :update_post_deleted_at, if: :persisted?

  private

  def update_goals_deleted_at
    goals.find_each { |goal| goal.update(deleted_at: Time.current) }
  end

  def update_categories_deleted_at
    categories.find_each do |category|
      category.update(deleted_at: Time.current)
    end
  end

  def update_products_deleted_at
    products.find_each do |product|
      product.update(deleted_at: Time.current)
    end
  end

  def update_extras_deleted_at
    extras.find_each do |extra|
      extra.update(deleted_at: Time.current)
    end
  end

  def update_flavors_deleted_at
    flavors.find_each do |flavor|
      flavor.update(deleted_at: Time.current)
    end
  end

  def update_delivery_locations_deleted_at
    delivery_locations.find_each do |delivery_location|
      delivery_location.update(deleted_at: Time.current)
    end
  end

  def update_clerk_deleted_at
    clerks.find_each do |clerk|
      clerk.update(deleted_at: Time.current)
    end
  end

  def update_order_deleted_at
    orders.find_each do |order|
      order.update(deleted_at: Time.current)
    end
  end

  def update_post_deleted_at
    posts.find_each do |post|
      post.update(deleted_at: Time.current)
    end
  end
end
