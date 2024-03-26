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
class Goal < ApplicationRecord
  acts_as_paranoid
  acts_as_tenant :client
  has_many :tasks, dependent: :destroy

  belongs_to :client

  enum status: { backlog: 'backlog', todo: 'todo', block: 'block',
                 doing: 'doing', done: 'done' }

  validates :name, presence: true

  accepts_nested_attributes_for :tasks, allow_destroy: true,
                                        reject_if: :all_blank
  after_update :after_update

  before_destroy :update_tasks_deleted_at, if: :persisted?

  def after_update
    GoalFinishedJob.perform_later(self)
  end

  def to_s
    name
  end

  def done!
    self.status = :done
    save!
  end

  private

  def update_tasks_deleted_at
    tasks.find_each { |g| g.update(deleted_at: Time.current) }
  end
end
