module Goals
  class FetchService < BusinessApplication
    def initialize(params)
      @params = params
    end

    def call
      query = Goal.ransack(@params[:q])
      results = query.result(distinct: true)

      if results.is_a?(ActiveRecord::Relation)
        results.order('created_at DESC').page(@params[:page]).per(4)
      else
        sorted_goals = results.sort_by(&:created_at).reverse
        Kaminari.paginate_array(sorted_goals).page(@params[:page]).per(4)
      end
    end
  end
end
