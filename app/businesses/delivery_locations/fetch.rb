module DeliveryLocations
  class Fetch < ApplicationFetch
    private

    def model_class
      DeliveryLocation
    end
  end
end
