module Manager
  class ConfigDeliveriesController < InternalController
    before_action :set_client, only: %i[edit_config update_config]
    before_action :set_config_delivery, only: %i[edit_config update_config]

    def edit_config; end

    def update_config
      if @config_delivery.persisted?
        update_config_delivery
      else
        create_config_delivery
      end

      redirect_to manager_edit_config_path,
                  notice: t('controllers.manager.config_deliveries.update')
    rescue StandardError => e
      redirect_to manager_edit_config_path,
                  notice: t('controllers.manager.config_deliveries.error')
    end

    private

    def config_delivery_params
      params.require(:config_delivery).permit(
        :delivery_forecast, :delivery_fee,
        :opening_time, :closing_time,
        :deleted_at
      )
    end

    def set_client
      @client = current_user.client
    end

    def create_config_delivery
      @config_delivery = ConfigDelivery.new(config_delivery_params)
      @config_delivery.client = current_user.client
      @config_delivery.save!
    end

    def update_config_delivery
      @config_delivery.update!(config_delivery_params)
    end

    def set_config_delivery
      @config_delivery = ConfigDelivery
                         .find_by(client: @client) || ConfigDelivery.new
    end
  end
end
