module Manager
  class DeliveryLocationsController < InternalController
    def index
      @delivery_locations = DeliveryLocation.all
    end
  end
end
