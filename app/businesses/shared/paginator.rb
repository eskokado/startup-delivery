module Shared
  class Paginator < BusinessApplication
    attr_reader :results, :page, :per_page

    def initialize(results, page, per_page)
      @results = results
      @page = page
      @per_page = per_page
    end

    def call
      return paginate_relation if results.is_a?(ActiveRecord::Relation)

      paginate_array
    end

    private

    def paginate_relation
      @results.order(created_at: :desc).page(page).per(per_page)
    end

    def paginate_array
      sorted = @results.sort_by(&:created_at).reverse
      Kaminari.paginate_array(sorted).page(page).per(per_page)
    end
  end
end
