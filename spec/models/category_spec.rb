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
require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_one_attached(:image) }
  end

  describe 'acts_as_paranoid' do
    it 'soft deletes the category' do
      category = create(:category)

      expect { category.destroy }.to change(Category.only_deleted, :count).by(1)
    end
  end
end
