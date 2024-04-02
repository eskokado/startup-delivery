module Manager
  module ManagerActionsSupport
    extend ActiveSupport::Concern

    def path_for(resource)
      raise NotImplementedError, 'You must implement path_for(resource)'
    end

    private

    def redirect_to_success(resource, action)
      redirect_to path_for(resource),
                  notice: t("controllers.manager.#{controller_name}.#{action}")
    end

    def render_failure(view)
      flash.now[:alert] = t("controllers.manager.#{controller_name}.error")
      render view, status: :unprocessable_entity
    end

    def set_current_client_context
      @client = current_user.client
    end

    def create_resource(resource, resource_params,
                        success_action:, failure_view:)
      resource.assign_attributes(resource_params)
      resource.client = @client if @client && resource.respond_to?(:client=)

      if resource.save
        redirect_to_success(resource, success_action)
      else
        render_failure(failure_view)
      end
    end

    def update_resource(resource, resource_params, success_action:,
                        failure_view:, purge_attachment: nil)
      purge_attachment_if_requested(resource, purge_attachment) if
        purge_attachment
      if resource.update(resource_params)
        redirect_to_success(resource, success_action)
      else
        render_failure(failure_view)
      end
    end

    def purge_attachment_if_requested(resource, attachment_key)
      attachment = resource.send(attachment_key)
      attachment.purge if
        params[resource.model_name.param_key][attachment_key] == '1'
    end

    def prepare_resource(resource_class)
      resource = find_resource(resource_class)
      handle_resource_not_found(resource_class) unless resource
    end

    def find_resource(resource_class)
      current_user.client.send(resource_class.to_s.downcase.pluralize)
                  .find_by(id: params[:id]).tap do |resource|
        instance_variable_set("@#{resource_class.to_s.downcase}", resource)
      end
    end

    def handle_resource_not_found(resource_class)
      redirect_to_not_found(resource_class)
    end

    def redirect_to_not_found(resource_class)
      redirect_to(
        send("manager_#{resource_class.to_s.downcase.pluralize}_path"),
        alert: t("controllers.manager.#{resource_class.to_s.downcase.pluralize}
                  .not_found")
      ) and return
    end
  end
end
