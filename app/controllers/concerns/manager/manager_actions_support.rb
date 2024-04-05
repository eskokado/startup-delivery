module Manager
  module ManagerActionsSupport
    extend ActiveSupport::Concern

    included do
      helper_method :path_for, :redirect_to_not_found
      before_action :set_current_client_context
    end

    def path_for(resource)
      raise NotImplementedError, 'You must implement path_for(resource)'
    end

    private

    def index_with_fetch(module_name)
      fetch_class = "#{module_name}::Fetch".constantize
      fetch_instance = fetch_class.new(params, client: @client)
      @q = fetch_instance.search
      instance_variable_set(
        "@#{module_name.underscore.pluralize}",
        fetch_instance.call
      )
    end

    def redirect_to_notice(resource, action, status = :found)
      redirect_to path_for(resource),
                  notice: t("controllers.manager.#{controller_name}.#{action}"),
                  status: status
    end

    def render_alert(view, status = :unprocessable_entity)
      flash.now[:alert] = t("controllers.manager.#{controller_name}.error")
      render view, status: status
    end

    def set_current_client_context
      @client = current_user.client
    end

    def process_resource(resource, params:,
                         success_action:, failure_view:, &block)
      resource.assign_attributes(params)
      resource.client ||= @client if resource.respond_to?(:client=)

      if block.call(resource)
        redirect_to_notice(resource, success_action)
      else
        render_alert(failure_view)
      end
    end

    def create_resource(resource, params, success_action:, failure_view:)
      process_resource(resource,
                       params: params,
                       success_action: success_action,
                       failure_view: failure_view, &:save)
    end

    def update_resource(resource, params,
                        success_action:, failure_view:, purge_attachment: nil)
      process_resource(resource,
                       params: params,
                       success_action: success_action,
                       failure_view: failure_view) do |r|
        purge_attachment_if_requested(r, purge_attachment) if purge_attachment
        r.update(params)
      end
    end

    def purge_attachment_if_requested(resource, attachment_key)
      return unless
        params[resource.model_name.param_key][attachment_key] == '1'

      resource.send(attachment_key).purge
    end

    def prepare_resource(resource_class)
      resource = find_resource(resource_class)
      redirect_to_not_found(resource_class) unless resource
    end

    def find_resource(resource_class)
      resource_name = resource_class.to_s.downcase
      current_user.client
                  .send(resource_name.pluralize.to_s)
                  .find_by(id: params[:id]).tap do |resource|
        instance_variable_set("@#{resource_name}", resource)
      end
    end

    def redirect_to_not_found(resource_class)
      resource_name = resource_class.to_s.downcase
      redirect_to(
        send("manager_#{resource_name.pluralize}_path"),
        alert: t(
          "controllers.manager.#{resource_name.pluralize}.not_found"
        )
      ) and return
    end
  end
end
