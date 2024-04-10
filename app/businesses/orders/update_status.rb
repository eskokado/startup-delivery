module Orders
  class UpdateStatus < BusinessApplication
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def call
      update_status(order)
    end

    private

    def update_status(order)
      current_status = order.status

      next_status = case current_status
                    when 'Waiting'
                      'Started'
                    when 'Started'
                      'Prepared'
                    when 'Prepared'
                      'Dispatched'
                    when 'Dispatched'
                      'Completed'
                    else
                      current_status
                    end

      order.update(status: next_status)
    end
  end
end
