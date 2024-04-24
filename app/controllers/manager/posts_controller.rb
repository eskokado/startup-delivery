module Manager
  class PostsController < InheritedResources::Base
    def index
      @params = { q: params[:q], page: params[:page] }
      @fetcher = Posts::Fetch.new(@params, current_user.client)
      @q = @fetcher.search
      @posts = @fetcher.call
    end

    private

    def build_resource(*args)
      super.tap do |resource|
        resource.client = current_user.client
      end
    end

    def post_params
      params.require(:post).permit(:title, :content, :image)
    end
  end
end
