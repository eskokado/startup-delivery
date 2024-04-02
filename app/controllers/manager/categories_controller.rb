module Manager
  class CategoriesController < InternalController
    include ManagerActionsSupport

    before_action :build_category, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action :set_category, only: %i[show edit update destroy]

    def index
      fetch = ::Categories::Fetch.new(params, client: @client)
      @q = fetch.search
      @categories = fetch.call
    end

    def show; end

    def new
      @category = Category.new
    end

    def create
      @category.assign_attributes(category_params.merge(client: @client))
      create_resource(@category,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @category,
        category_params,
        success_action: 'update',
        failure_view: :edit,
        purge_attachment: :image
      )
    end

    def destroy
      @category.destroy
      redirect_to manager_categories_path,
                  notice: t('controllers.manager.categories.destroy')
    end

    private

    def category_params
      params.require(:category).permit(:name, :description, :image)
    end

    def set_category
      @category = Category.find(params[:id])
      @category.client = current_user.client
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        manager_categories_path,
        alert: t('controllers.manager.categories.not_found')
      )
    end

    def build_category
      @category = Category.new(category_params)
    end

    def success_path_for(resource)
      manager_category_path(resource)
    end

    def path_for(resource)
      manager_category_path(resource)
    end
  end
end
