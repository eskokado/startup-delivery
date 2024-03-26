module Goals
  class FetchService < BusinessApplication
    PER_PAGE = 4
    attr_reader :search

    def initialize(params)
      @params = params
      @search = Goal.ransack(@params[:q])
    end

    def call
      results = @search.result(distinct: true)
      paginate(results)
    end

    private

    def paginate(results)
      if results.is_a?(ActiveRecord::Relation)
        results.order(created_at: :desc).page(@params[:page]).per(PER_PAGE)
      else # Quando results é um Array
        sorted_goals = results.sort_by(&:created_at).reverse
        Kaminari.paginate_array(sorted_goals).page(@params[:page]).per(PER_PAGE)
      end
    end
  end
end
