require 'rails_helper'

RSpec.describe Manager::OrdersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:client) { create(:client, user: user) }

  let(:orders) { create_list(:order, 3, client: client) }
  let(:order) { create(:order, client: client) }

  before(:each) do
    allow_any_instance_of(InternalController)
      .to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @orders' do
      order = FactoryBot.create(:order, client: client)
      get :index
      expect(assigns(:orders)).to eq([order])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns @orders for the given search parameters' do
      double('search_result', result: orders)
      allow(Order)
        .to receive_message_chain(:ransack, :result).and_return(orders)

      get :index

      expect(assigns(:orders)).to match_array(orders)
    end
  end

  describe 'GET #index with search' do
    it 'returns the orders searched correctly' do
      order1 = create(:order, date: '2024-04-07', client: client)
      order2 = create(:order, date: '2024-04-06', client: client)
      get :index,
          params: { q: { date_eq: '2024-04-07' } }

      expect(assigns(:orders)).to include(order1)
      expect(assigns(:orders)).to_not include(order2)
    end

    it 'excludes non-matching results' do
      create(:order, date: '2024-04-07', client: client)

      get :index,
          params: { q: { date_eq: '2024-01-01' } }

      expect(assigns(:orders)).to be_empty
    end

    it 'renders the index template' do
      get :index,
          params: { q: { date_eq: '2024-01-01' } }

      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show_consumer' do
    it 'assigns the requested order to @order' do
      get :show_consumer, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
    end

    it 'renders the :show_consumer template' do
      get :show_consumer, params: { id: order.id }
      expect(response).to render_template :show_consumer
    end
  end

  describe 'GET #show_products' do
    it 'assigns the requested order to @order' do
      get :show_products, params: { id: order.id }
      expect(assigns(:order)).to eq(order)
    end

    it 'renders the :show_consumer template' do
      get :show_products, params: { id: order.id }
      expect(response).to render_template :show_products
    end
  end

  describe 'GET #generate_pdf_receipt' do
    let(:order) { create(:order, client: client) }
    let(:pdf_generator) { instance_double(Orders::GeneratePdfReceipt) }
    let(:pdf_data) { double(render: 'PDF DATA') }

    before do
      allow(Orders::GeneratePdfReceipt)
        .to receive(:new).and_return(pdf_generator)
      allow(pdf_generator).to receive(:call).and_return(pdf_data)
    end

    it 'generates a PDF receipt and sends it as inline disposition' do
      get :generate_pdf_receipt, params: { id: order.id }
      expect(response.headers['Content-Type']).to eq 'application/pdf'
      expect(response.headers['Content-Disposition']).to include('inline')
      expect(response.body).to eq 'PDF DATA'
    end

    it 'renders the PDF with the correct filename' do
      get :generate_pdf_receipt, params: { id: order.id }
      expect(response.headers['Content-Disposition'])
        .to include("filename=\"comprovante_pedido_#{order.id}.pdf\"")
    end
  end

  describe 'PATCH #update_status' do
    let(:update_status_business) { instance_double(Orders::UpdateStatus) }

    before do
      allow(Orders::UpdateStatus)
        .to receive(:new).with(order).and_return(update_status_business)
    end

    context 'when the order status is successfully updated' do
      it 'redirects to the manager_orders_path with a notice message' do
        allow(update_status_business).to receive(:call).and_return(true)

        post :update_status, params: { id: order.id }

        expect(response).to redirect_to(manager_orders_path)
        expect(flash[:notice])
          .to eq(I18n.t('controllers.manager.orders.update'))
      end
    end

    context 'when the order status update fails' do
      it 'redirects to the manager_orders_path with an error message' do
        allow(update_status_business).to receive(:call).and_return(false)

        post :update_status, params: { id: order.id }

        expect(response).to redirect_to(manager_orders_path)
        expect(flash[:notice]).to eq(I18n.t('controllers.manager.orders.error'))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the order and redirects with a notice message' do
      allow_any_instance_of(Orders::Destroy)
        .to receive(:call).and_return(true)

      delete :destroy, params: { id: order.id }

      expect(response).to redirect_to(manager_orders_path)
      expect(flash[:notice]).to eq(I18n.t('controllers.manager.orders.destroy'))
    end

    it 'redirects with an error message when order deletion fails' do
      allow_any_instance_of(Orders::Destroy)
        .to receive(:call).and_return(false)

      delete :destroy, params: { id: order.id }

      expect(response).to redirect_to(manager_orders_path)
      expect(flash[:notice])
        .to eq(I18n.t('controllers.manager.orders.not_allowed_to_delete'))
    end
  end
end
