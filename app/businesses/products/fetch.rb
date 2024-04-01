module Products
  class Fetch < ApplicationFetch
    private

    def model_class
      Product
    end
  end
end
