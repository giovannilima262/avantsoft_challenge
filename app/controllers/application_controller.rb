class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  before_action :authorize
  
  def authorize
    header = request.headers['Authorization']
    token = header.split.last if header

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)
      @current_user = User.find(decoded[0]['user_id'])
    rescue
      render json: { error: 'Not authorize' }, status: :unauthorized
    end
  end
end
