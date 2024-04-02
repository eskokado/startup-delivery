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

    def create_resource(resource, success_action:, failure_view:)
      if resource.save
        redirect_to_success(resource, success_action)
      else
        render_failure(failure_view)
      end
    end

    def update_resource(
      resource,
      resource_params,
      success_action:,
      failure_view:,
      purge_attachment: nil
    )
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
  end
end
