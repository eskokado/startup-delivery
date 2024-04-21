RSpec.describe Devise::ConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #show' do
    let(:user) { create(:user, confirmed_at: nil) }

    context 'with valid confirmation token' do
      before do
        user.send_confirmation_instructions
        get :show, params: { confirmation_token: user.confirmation_token }
      end

      it 'confirms the user' do
        user.reload
        expect(user.confirmed?).to be true
      end

      it 'redirects to the new user session path with a success notice' do
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq I18n.t('devise.confirmations.confirmed')
      end
    end

    context 'with invalid confirmation token' do
      before do
        get :show, params: { confirmation_token: 'invalid_token' }
      end

      it 'does not confirm the user' do
        user.reload
        expect(user.confirmed?).to be false
      end

      it 'redirects to the new user session path with a failure notice' do
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq I18n.t('devise.failure.unconfirmed')
      end
    end
  end
end
