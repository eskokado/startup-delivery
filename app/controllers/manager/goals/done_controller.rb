module Manager
  module Goals
    class DoneController < InternalController
      before_action :get_goal,
                    only: %i[index show]

      def index
        @goal.done!
        respond_to do |format|
          format.html do
            redirect_to manager_goals_path,
                        notice: t('controllers.manager.goals.done.one')
          end
        end
      end

      def show
        @goal.done!
        respond_to do |format|
          format.html do
            redirect_to manager_goal_path(@goal),
                        notice: t('controllers.manager.goals.done.one')
          end
        end
      end

      def many
        Goal.where(id: params[:done][:goal_ids])
            .update(status: :done)

        respond_to do |format|
          format.json do
            render json: { message: t('controllers.manager.goals.done.other') },
                   status: :ok
          end
        end
      end

      private

      def get_goal
        @goal = Goal.find(params[:goal_id])
      end
    end
  end
end
