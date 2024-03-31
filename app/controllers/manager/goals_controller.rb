module Manager
  class GoalsController < InternalController
    before_action :set_goal, only: %i[show edit update destroy]

    def index
      fetch = ::Goals::Fetch.new(params)
      @q = fetch.search
      @goals = fetch.call
    end

    def show; end

    def new
      @goal = Goal.new
      @goal.tasks.build
    end

    def edit; end

    def create
      @goal = Goal.new(goal_params)
      @goal.client = current_user.client
      if @goal.save
        redirect_to_success(manager_goal_path(@goal), 'create')
      else
        render_failure(:new)
      end
    end

    def update
      if @goal.update(goal_params)
        redirect_to_success(manager_goal_path(@goal), 'update')
      else
        render_failure(:edit)
      end
    end

    def destroy
      @goal.destroy
      redirect_to manager_goals_path,
                  notice: t('controllers.manager.goals.destroy')
    end

    private

    def set_goal
      @goal = Goal.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(manager_goals_path, alert: 'Goal not found')
    end

    def goal_params
      params.require(:goal)
            .permit(:name, :description, :status,
                    tasks_attributes: %i[id name description status _destroy])
    end

    def redirect_to_success(path, action)
      redirect_to path, notice: t("controllers.manager.goals.#{action}")
    end

    def render_failure(template)
      render template, status: :unprocessable_entity
    end
  end
end
