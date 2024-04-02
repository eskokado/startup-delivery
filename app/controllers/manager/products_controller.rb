module Manager
  class ProductsController < InternalController
    include ManagerActionsSupport

    before_action :build_product, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action :set_product, only: %i[edit update]

    def index
      fetch = ::Products::Fetch.new(params, client: @client)
      @q = fetch.search
      @products = fetch.call
    end

    def new
      @product = Product.new
    end

    def create
      @product.assign_attributes(product_params.merge(client: @client))
      create_resource(@product,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      @product.photo.purge if params[:product][:remove_photo] == '1'

      if @product.update(product_params)
        redirect_to_success(@product, 'update')
      else
        render_failure(:edit)
      end
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

    def set_product
      @product = Product.find(params[:id])
      @product.client = current_user.client
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        manager_products_path,
        alert: t('controllers.manager.products.not_found')
      )
    end

    def path_for(resource)
      manager_product_path(resource)
    end
  end
end
