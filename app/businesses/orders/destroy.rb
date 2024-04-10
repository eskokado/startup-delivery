module Orders
  class Destroy < BusinessApplication
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def call
      destroy(order)
    end

    private

    def destroy(order)
      if order.status == 'Waiting'
        @order.destroy
        true
      else
        false
      end
    end
  end
end
