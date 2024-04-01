module Manager
  class ProductsController < InternalController
    before_action :set_client, only: %i[index create]
    before_action :build_product, only: %i[create]

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
      if @product.save
        redirect_to manager_product_path(@product),
                    notice: t('controllers.manager.products.create')
      else
        flash.now[:alert] = t('controllers.manager.products.error')
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_client
      @client = current_user.client
    end

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
  end
end
