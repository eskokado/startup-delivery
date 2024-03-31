module Categories
  class Fetch < BusinessApplication
    PER_PAGE = 4
    attr_reader :search

    def initialize(params, client)
      @params = params
      @client = client
      configure_search
    end

    def call
      results = @search.result(distinct: true)
      paginate_results(results)
    end

    private

    def configure_search
      search_params = @params.fetch(:q, {}).merge(client_eq: @client)
      @search = Category.ransack(search_params)
    end

    def paginate_results(results)
      paginator = ::Shared::Paginator.new(results, @params[:page], PER_PAGE)
      paginator.call
    end
  end
end
