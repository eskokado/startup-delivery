class ApplicationFetch < BusinessApplication
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

  def model_class
    raise NotImplementedError, "This #{self.class.name} cannot respond to:"
  end

  def configure_search
    search_params = @params.fetch(:q, {}).merge(client_eq: @client)
    @search = model_class.ransack(search_params)
  end

  def paginate_results(results)
    paginator = ::Shared::Paginator.new(results, @params[:page], PER_PAGE)
    paginator.call
  end
end
