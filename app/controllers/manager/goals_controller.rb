module Manager
  class GoalsController < InternalController
    before_action :set_goal,
                  only: %i[show edit update
                           destroy]

    def index
      @q = Goal.ransack(params[:q])
      results = @q.result(distinct: true)
      if results.is_a?(ActiveRecord::Relation)
        @goals = results.order('created_at DESC').page(params[:page]).per(4)
      else
        sorted_goals = results.sort_by(&:created_at).reverse
        @goals = Kaminari.paginate_array(sorted_goals).page(params[:page]).per(4)
      end
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
      respond_to do |format|
        if @goal.save
          format.html do
            redirect_to manager_goal_path(@goal),
                        notice: t('controllers.manager.goals.create')
          end
        else
          format.html do
            render :new,
                   status: :unprocessable_entity
          end
        end
      end
    end

    def update
      respond_to do |format|
        if @goal.update(goal_params)
          format.html do
            redirect_to manager_goal_path(@goal),
                        notice: t('controllers.manager.goals.update')
          end
        else
          format.html do
            render :edit,
                   status: :unprocessable_entity
          end
        end
      end
    end

    def destroy
      @goal.destroy
      respond_to do |format|
        format.html do
          redirect_to manager_goals_path,
                      notice: t('controllers.manager.goals.destroy')
        end
      end
    end

    private

    def set_goal
      @goal = Goal.find_by(id: params[:id])
      redirect_to(manager_goals_path, alert: "Goal not found") unless @goal
    end

    def goal_params
      params.require(:goal).permit(:name,
                                   :description, :status,
                                   tasks_attributes:
                                     %i[id name description status _destroy])
    end
  end
end
