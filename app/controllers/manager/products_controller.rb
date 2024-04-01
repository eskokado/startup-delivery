module Manager
  class ProductsController < InternalController
    def index
      client = current_user.client
      fetch = ::Products::Fetch.new(params, client: client)
      @q = fetch.search
      @products = fetch.call
    end
  end
end
