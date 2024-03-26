module Manager
  module Goals
    class DoneController < InternalController
      before_action :set_goal,
                    only: %i[one]

      def one
        @goal.done!
        respond_to do |format|
          format.html do
            redirect_to manager_goals_path,
                        notice: t('controllers.manager.goals.done.one')
          end
        end
      end

      def many
        Goal.where(id: params[:done][:goal_ids])
            .find_each { |goal| goal.update(status: :done) }

        respond_to do |format|
          format.html do
            redirect_to manager_goals_path,
                        notice: t('controllers.manager.goals.done.other')
          end
        end
      end

      private

      def set_goal
        @goal = Goal.find(params[:goal_id])
      end
    end
  end
end
