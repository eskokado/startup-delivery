module Clerks
  class Fetch < ApplicationFetch
    private

    def model_class
      Clerk
    end
  end
end
