module Manager
  module ManagerActionsSupport
    extend ActiveSupport::Concern

    included do
      # Define este método no seu controller para especificar o caminho de redirecionamento
      # para o método `redirect_to_success`.
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
    end
  end
end
