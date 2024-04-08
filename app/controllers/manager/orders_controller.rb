module Manager
  class OrdersController < InternalController
    include ManagerActionsSupport

    before_action :set_current_client_context, only: %i[index]
    before_action -> { prepare_resource(Order) },
                  only: %i[show_consumer show_products]

    def index
      index_with_fetch('Orders')
    end

    def show_consumer; end

    def show_products; end

    private

    def path_for(resource)
      manager_flavor_path(resource)
    end
  end
end
