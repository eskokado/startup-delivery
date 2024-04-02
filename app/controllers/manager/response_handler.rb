module Manager
  module ResponseHandler
    extend ActiveSupport::Concern

    included do
      def redirect_to_success(resource, action)
        redirect_to path_for(resource),
                    notice:
                      t("controllers.manager.#{controller_name}.#{action}")
      end

      def render_failure(view)
        flash.now[:alert] = t("controllers.manager.#{controller_name}.error")
        render view, status: :unprocessable_entity
      end

      private

      # Define this method in your controller to specify the redirect path
      # for the `redirect_to_success` method.
      def path_for(resource)
        raise NotImplementedError, 'You must implement path_for(resource)'
      end
    end
  end
end
