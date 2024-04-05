class DeliveryLocation < ApplicationRecord
  acts_as_paranoid

  belongs_to :client

  validates :name, :value, presence: true
  validates :value, numericality: { greater_than: 0 }
end
