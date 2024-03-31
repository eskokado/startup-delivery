module Manager
  class ProductsController < InternalController
    def index
      @products = Product.all
    end
  end
end
