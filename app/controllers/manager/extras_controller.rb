module Manager
  class ExtrasController < InternalController
    include ManagerActionsSupport
    before_action :build_extra, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action -> { prepare_resource(Extra) },
                  only: %i[edit update]

    def index
      fetch = ::Extras::Fetch.new(params, client: @client)
      @q = fetch.search
      @extras = fetch.call
    end

    def new
      @extra = Extra.new
    end

    def create
      create_resource(@extra, extra_params,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @extra,
        extra_params,
        success_action: 'update',
        failure_view: :edit
      )
    end

    private

    def build_extra
      @extra = Extra.new(extra_params)
    end

    def extra_params
      params.require(:extra).permit(
        :name,
        :value,
        :category_id
      )
    end

    def path_for(resource)
      manager_extra_path(resource)
    end
  end
end
