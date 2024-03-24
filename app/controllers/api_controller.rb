class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
