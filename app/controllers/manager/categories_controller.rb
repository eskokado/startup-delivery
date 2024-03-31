module Manager
  class CategoriesController < InternalController
    before_action :set_category, only: %i[show edit update destroy]

    def index
      client = current_user.client
      fetch = ::Categories::Fetch.new(params, client: client)
      @q = fetch.search
      @categories = fetch.call
    end

    def show; end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      @category.client = current_user.client
      respond_to do |format|
        if @category.save
          format.html do
            redirect_to manager_category_path(@category),
                        notice: t('controllers.manager.categories.create')
          end
        else
          format.html do
            render :new,
                   status: :unprocessable_entity
          end
        end
      end
    end

    def edit; end

    def update
      @category.image.purge if params[:category][:remove_image] == '1'

      if @category.update(category_params)
        redirect_to_success(manager_category_path(@category), 'update')
      else
        render_failure(:edit)
      end
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

    def redirect_to_success(path, action)
      redirect_to path, notice: t("controllers.manager.categories.#{action}")
    end
  end
end
