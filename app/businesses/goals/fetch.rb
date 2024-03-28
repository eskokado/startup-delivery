module Goals
  class Fetch < BusinessApplication
    PER_PAGE = 4
    attr_reader :search

    def initialize(params)
      @params = params
      @search = Goal.ransack(@params[:q])
    end

    def call
      results = @search.result(distinct: true)
      paginate_results(results)
    end

    private

    def paginate_results(results)
      paginator = Paginator.new(results, @params[:page])
      paginator.paginate
    end
  end

  # Extracts pagination logic into its own class
  class Paginator
    attr_reader :results, :page

    def initialize(results, page)
      @results = results
      @page = page
    end

    def paginate
      return paginate_relation if results.is_a?(ActiveRecord::Relation)
      paginate_array
    end

    private

    def paginate_relation
      results.order(created_at: :desc).page(page).per(Fetch::PER_PAGE)
    end

    def paginate_array
      sorted_goals = results.sort_by(&:created_at).reverse
      Kaminari.paginate_array(sorted_goals).page(page).per(Fetch::PER_PAGE)
    end
  end
end
