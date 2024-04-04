module Manager
  class FlavorsController < InternalController
    def index
      @flavors = Flavor.all
    end
  end
end
