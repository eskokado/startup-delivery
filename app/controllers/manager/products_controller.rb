module Manager
  class ProductsController < InternalController
    include ManagerActionsSupport

    before_action :build_product, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action -> { prepare_resource(Product) },
                  only: %i[show edit update destroy]

    def index
      index_with_fetch('Products')
    end

    def show; end

    def new
      @product = Product.new
    end

    def create
      create_resource(@product, product_params,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @product,
        product_params,
        success_action: 'update',
        failure_view: :edit,
        purge_attachment: :photo
      )
    end

    def destroy
      @product.destroy
      redirect_to manager_products_path,
                  notice: t('controllers.manager.products.destroy')
    end

    private

    def build_product
      @product = Product.new(product_params)
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

    def path_for(resource)
      manager_product_path(resource)
    end
  end
end
