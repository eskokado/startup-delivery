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
      paginator = ::Shared::Paginator.new(results, @params[:page], PER_PAGE)
      paginator.call
    end

  end
end
