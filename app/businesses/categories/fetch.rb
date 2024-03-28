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
      paginate(results)
    end

    private

    def configure_search
      search_params = @params.fetch(:q, {}).merge(client_eq: @client)
      @search = Category.ransack(search_params)
    end

    def paginate(results)
      if results.is_a?(ActiveRecord::Relation)
        results.order(created_at: :desc).page(@params[:page]).per(PER_PAGE)
      else
        sorted_goals = results.sort_by(&:created_at).reverse
        Kaminari.paginate_array(sorted_goals).page(@params[:page]).per(PER_PAGE)
      end
    end
  end
end
