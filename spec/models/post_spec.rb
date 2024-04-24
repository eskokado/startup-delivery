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
require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'is valid with valid attributes' do
    post = FactoryBot.create(:post)
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post = build(:post, title: nil)
    expect(post).not_to be_valid
  end

  it 'is not valid without a content' do
    post = build(:post, content: nil)
    expect(post).not_to be_valid
  end

  describe 'associations' do
    it { should belong_to(:client) }
  end
end
