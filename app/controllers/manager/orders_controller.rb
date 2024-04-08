module Manager
  class OrdersController < InternalController
    include ManagerActionsSupport

    before_action :set_current_client_context, only: %i[index]

    def index
      index_with_fetch('Orders')
    end
  end
end