module Manager
  class ProductsController < InternalController
    def index
      client = current_user.client
      fetch = ::Products::Fetch.new(params, client: client)
      @q = fetch.search
      @products = fetch.call
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      @product.client = current_user.client
      respond_to do |format|
        if @product.save
          format.html do
            redirect_to manager_product_path(@product),
                        notice: t('controllers.manager.products.create')
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
