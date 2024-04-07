module Manager
  class OrdersController < InternalController
    def index
      @orders = Order.all
    end
  end
end
