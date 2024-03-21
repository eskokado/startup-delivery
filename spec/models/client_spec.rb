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
require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:goals).dependent(:destroy) }
  end
end
