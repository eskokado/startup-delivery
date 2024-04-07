module Orders
  class Fetch < ApplicationFetch
    private

    def model_class
      Order
    end
  end
end
