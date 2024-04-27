module Manager
  class ProductsController < InheritedResources::Base
    def index
      @params = { q: params[:q], page: params[:page] }
      @fetcher = Products::Fetch.new(@params, current_user.client)
      @q = @fetcher.search
      @products = @fetcher.call
    end

    def create
      create! do |success, failure|
        success.html do
          redirect_to manager_products_path, notice: 'Produto criado com sucesso!'
        end

        failure.html do
          flash.now[:error] = resource.errors.full_messages.join(', ')
          if resource.persisted?
            redirect_to edit_manager_product_path(resource)
          else
            render :new
          end
        end
      end
    end

    def update
      update! do |success, failure|
        success.html do
          flash[:notice] = 'Recurso atualizado com sucesso.'
          redirect_to manager_products_path
        end

        failure.html do
          flash[:error] = resource.errors.full_messages.join(', ')
          render :edit
        end
      end
    end

    private

    def build_resource(*args)
      super.tap do |resource|
        resource.client = current_user.client
      end
    end

    def product_params
      params.require(:product).permit(
        :name,
        :description,
        :long_description,
        :photo,
        :combo,
        :pizza,
        :value,
        :category_id
      )
    end
  end
end
