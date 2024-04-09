module Orders
  class GeneratePdfReceipt < BusinessApplication
    attr_reader :order, :pdf

    def initialize(order)
      @order = order
      @pdf = Prawn::Document.new(page_size: [300, 420],
                                 margin: [10, 10, 10, 10])
    end

    def call
      generate_pdf_receipt(order)
    end

    private

    def generate_pdf_receipt(order)
      @pdf.font 'Helvetica'
      write_client_info(order)
      write_consumer_info(order)
      subtotal = write_order_items(order)
      write_totals(order, subtotal)
      write_payment_delivery(order)
      write_address_delivery(order)
      write_order_id(order)
      @pdf.font 'Helvetica'
      @pdf
    end

    def write_client_info(order)
      @pdf.text order.client.user.name.to_s, align: :center, size: 18
      @pdf.text order.client.document.to_s, align: :center, size: 14
      @pdf.move_down 10
    end

    def write_consumer_info(order)
      @pdf.text order.consumer.user.name, align: :center
      @pdf.text order.consumer.document, align: :center
      @pdf.move_down 10
    end

    def write_order_items(order)
      @pdf.font 'Helvetica-Bold'
      @pdf.text 'CUPOM NÃO FISCAL', align: :center, size: 13
      @pdf.font 'Helvetica'
      @pdf.move_down 10
      subtotal = write_products(order)
      @pdf.move_down 10
      subtotal
    end

    def write_products(order)
      subtotal = 0
      order.order_items.each do |item|
        quantity = format('%03d', item.quantity)
        name = item.product.name.ljust(35, ' ')
        total = item.quantity * item.product.value
        total_format = format('%.2f', total).rjust(10, ' ')
        subtotal += total
        @pdf.text "#{quantity} #{name} #{total_format}"
      end
      subtotal
    end

    def write_totals(order, subtotal)
      subtotal_format = format('%.2f', subtotal)
      fixed_delivery_format = format('%.2f', order.fixed_delivery)
      total_format = format('%.2f', order.total)
      total_paid_format = format('%.2f', order.total_paid)
      change_format = format('%.2f', order.change)
      @pdf.text "Subtotal: R$ #{subtotal_format}"
      @pdf.text "Taxa de entrega: R$ #{fixed_delivery_format}"
      @pdf.text "Total: R$ #{total_format}"
      @pdf.text "Total pago: R$ #{total_paid_format}"
      @pdf.text "Troco: R$ #{change_format}"
      @pdf.move_down 10
    end

    def write_payment_delivery(order)
      @pdf.font 'Helvetica-Bold'
      @pdf.text 'PAGAMENTO E ENTREGA', align: :center, size: 13
      @pdf.font 'Helvetica'
      @pdf.move_down 10
      @pdf.text "Forma de pagamento: #{order.payment_type}"
      @pdf.text "Pago: #{order.paid}"
      @pdf.move_down 10
    end

    def write_address_delivery(order)
      address_line1 = build_address_line1(order.consumer)
      address_line2 = build_address_line2(order.consumer)
      @pdf.text address_line1, align: :center, size: 10
      @pdf.text address_line2, align: :center, size: 10
      @pdf.move_down 10
    end

    def build_address_line1(consumer)
      "#{consumer.street}, #{consumer.number} - #{consumer.complement} - "\
        "Bairro #{consumer.district}"
    end

    def build_address_line2(consumer)
      "#{consumer.city} - #{consumer.state} - #{consumer.zipcode}"
    end

    def write_order_id(order)
      @pdf.font 'Helvetica-Bold'
      @pdf.text "Pedido #{order.id}", align: :center, size: 10
    end
  end
end
