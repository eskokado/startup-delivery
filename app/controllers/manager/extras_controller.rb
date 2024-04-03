module Manager
  class ExtrasController < InternalController
    include ManagerActionsSupport
    before_action :set_current_client_context, only: %i[index]

    def index
      @extras = Extra.all
    end
  end
end
