module Manager
  class ProductsController < InheritedResources::Base
    def index
      @params = { q: params[:q], page: params[:page] }
      @fetcher = Products::Fetch.new(@params, current_user.client)
      @q = @fetcher.search
      @products = @fetcher.call
    end

    def create
      create_product(success: -> { redirect_to manager_products_path }, failure: :render_new)
    end

    def update
      update_product(success: -> { redirect_to manager_products_path }, failure: :render_edit)
    end

    def destroy
      destroy_product(success: -> { redirect_to manager_products_path })
    end

    private

    def create_product(success:, failure:)
      create! do |success_callback, failure_callback|
        success_callback.html { success.call }
        failure_callback.html do
          flash.now[:error] = resource.errors.full_messages.join(', ')
          send(failure)
        end
      end
    end

    def update_product(success:, failure:)
      update! do |success_callback, failure_callback|
        success_callback.html do
          flash[:notice] = I18n.t('controllers.manager.products.update')
          success.call
        end
        failure_callback.html do
          flash[:error] = resource.errors.full_messages.join(', ')
          send(failure)
        end
      end
    end

    def destroy_product(success:)
      destroy! do |success_callback|
        success_callback.html do
          redirect_to manager_products_path, notice: I18n.t('controllers.manager.products.destroy')
        end
      end
    end

    def render_new
      render :new
    end

    def render_edit
      render :edit
    end

    def build_resource(*args)
      super.tap do |resource|
        resource.client = current_user.client
      end
    end

    def product_params
      params.require(:product).permit(
        :name,
        :description,
        :long_description,
        :photo,
        :combo,
        :pizza,
        :value,
        :category_id
      )
    end
  end
end
