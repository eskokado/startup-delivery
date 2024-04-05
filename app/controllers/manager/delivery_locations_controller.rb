module Manager
  class DeliveryLocationsController < InternalController
    include ManagerActionsSupport

    before_action :build_delivery_location, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action -> { prepare_resource(DeliveryLocation) },
                  only: %i[edit update]

    def index
      index_with_fetch('DeliveryLocations')
    end

    def new
      @delivery_location = DeliveryLocation.new
    end

    def create
      create_resource(@delivery_location, delivery_location_params,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @delivery_location,
        delivery_location_params,
        success_action: 'update',
        failure_view: :edit
      )
    end

    private

    def build_delivery_location
      @delivery_location = DeliveryLocation.new(delivery_location_params)
    end

    def delivery_location_params
      params.require(:delivery_location).permit(
        :name,
        :value
      )
    end

    def path_for(resource)
      manager_delivery_location_path(resource)
    end
  end
end
