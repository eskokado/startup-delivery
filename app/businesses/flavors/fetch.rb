module Flavors
  class Fetch < ApplicationFetch
    private

    def model_class
      Flavor
    end
  end
end
