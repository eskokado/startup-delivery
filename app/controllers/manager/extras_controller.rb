module Manager
  class ExtrasController < InternalController
    include ManagerActionsSupport
    before_action :set_current_client_context, only: %i[index]

    def index
      fetch = ::Extras::Fetch.new(params, client: @client)
      @q = fetch.search
      @extras = fetch.call
    end
  end
end
