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

  validates :document, presence: true

  before_destroy :update_goals_deleted_at, if: :persisted?
  before_destroy :update_categories_deleted_at, if: :persisted?
  before_destroy :update_products_deleted_at, if: :persisted?
  before_destroy :update_extras_deleted_at, if: :persisted?
  before_destroy :update_flavors_deleted_at, if: :persisted?

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
      extra.update(deleted_at: Time.current)
    end
  end
end
