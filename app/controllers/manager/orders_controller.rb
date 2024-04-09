module Manager
  class OrdersController < InternalController
    include ManagerActionsSupport

    before_action :set_current_client_context, only: %i[index]
    before_action -> { prepare_resource(Order) },
                  only: %i[show_consumer show_products generate_pdf_receipt]

    def index
      index_with_fetch('Orders')
    end

    def show_consumer; end

    def show_products; end

    def generate_pdf_receipt
      pdf_generator = Orders::GeneratePdfReceipt.new(@order)
      pdf_data = pdf_generator.call
      send_data pdf_data.render,
                filename: "comprovante_pedido_#{@order.id}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    end

    private

    def path_for(resource)
      manager_flavor_path(resource)
    end
  end
end
