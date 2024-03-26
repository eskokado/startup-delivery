module Manager
  class CategoriesController < InternalController
    def index
      client = current_user.client
      @categories = Category.where(client: client)
    end
  end
end
