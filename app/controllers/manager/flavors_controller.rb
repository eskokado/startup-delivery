module Manager
  class FlavorsController < InternalController
    include ManagerActionsSupport

    before_action :build_flavor, only: %i[create]
    before_action :set_current_client_context, only: %i[index create]
    before_action -> { prepare_resource(Flavor) },
                  only: %i[show edit update destroy]
    def index
      index_with_fetch('Flavors')
    end

    def new
      @flavor = Flavor.new
    end

    def create
      create_resource(@flavor, flavor_params,
                      success_action: 'create',
                      failure_view: :new)
    end

    def edit; end

    def update
      update_resource(
        @flavor,
        flavor_params,
        success_action: 'update',
        failure_view: :edit
      )
    end

    def show; end

    def destroy
      @flavor.destroy
      redirect_to manager_flavors_path,
                  notice: t('controllers.manager.flavors.destroy')
    end

    private

    def build_flavor
      @flavor = Flavor.new(flavor_params)
    end

    def flavor_params
      params.require(:flavor).permit(
        :name,
        :value
      )
    end

    def path_for(resource)
      manager_flavor_path(resource)
    end
  end
end
