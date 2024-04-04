module Manager
  class FlavorsController < InternalController
    include ManagerActionsSupport

    before_action :set_current_client_context, only: %i[index]
    def index
      fetch = ::Flavors::Fetch.new(params, client: @client)
      @q = fetch.search
      @flavors = fetch.call
    end
  end
end
