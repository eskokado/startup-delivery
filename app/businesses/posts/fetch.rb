module Posts
  class Fetch < ApplicationFetch
    private

    def model_class
      Post
    end
  end
end
