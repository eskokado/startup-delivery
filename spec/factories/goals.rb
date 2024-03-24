# == Schema Information
#
# Table name: goals
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  finished_at :datetime
#  name        :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer
#
# Indexes
#
#  index_goals_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :goal do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    status { 'todo' }
    association :client

    trait :with_tasks do
      after(:create) do |goal, _evaluator|
        create_list(:task, 3, goal: goal)
      end
    end
  end
end
