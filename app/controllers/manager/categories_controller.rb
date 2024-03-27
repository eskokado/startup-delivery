module Manager
  class CategoriesController < InternalController
    def index
      client = current_user.client
      @categories = Category.where(client: client)
    end

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

    private

    def category_params
      params.require(:category).permit(:name, :description, :image_url)
    end

  end
end
