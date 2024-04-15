module Manager
  class HomeController < InternalController
    def index
      today = Time.zone.today

      @total_clients = Client.count
      @total_orders_day = Order.where(date: today).count
      @total_orders_waiting = Order.where(status: 'Waiting').count
      @total_sold = Order.where(date: today).sum(:total)
    end
  end
end
