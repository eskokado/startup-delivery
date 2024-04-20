# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # Associações
  it { should have_one(:client) }
  it { should have_one_attached(:avatar) }

  # Validações
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe 'email provider by default' do
    it 'sets the provider to email' do
      user = create(:user)
      expect(user.provider).to eq('email')
    end
  end

  describe 'uid' do
    it 'sets the uid to the email if blank' do
      user = create(:user)
      expect(user.uid).to eq(user.email)
    end
  end
end
