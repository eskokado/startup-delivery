module Manager
  class ClerksController < InternalController
    include ManagerActionsSupport

    before_action :build_clerk, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action -> { prepare_resource(Clerk) },
                  only: %i[edit update]
    def index
      index_with_fetch('Clerks')
    end

    def new
      @clerk = Clerk.new
    end

    def create
      create_resource(@clerk, clerk_params,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @clerk,
        clerk_params,
        success_action: 'update',
        failure_view: :edit
      )
    end

    private

    def build_clerk
      @clerk = Clerk.new(clerk_params)
    end

    def clerk_params
      params.require(:clerk).permit(
        :name,
        :document,
        :phone,
        :person
      )
    end

    def path_for(resource)
      manager_clerk_path(resource)
    end
  end
end
