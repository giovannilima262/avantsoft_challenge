class AuthController < ApplicationController
  skip_before_action :authorize, only: [ :login ]

  api :POST, "/auth/login", "Get JWT token"
  param :name, String, desc: "User name", required: true
  param :password, String, desc: "User password", required: true
  def login
    user = User.find_by(name: login_params[:name])

    if user&.authenticate(login_params[:password])
      token = User.generate_token(user)
      render json: { token: token }, status: :ok
    else
      render json: { error: "name or password is invalid" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:name)
    params.require(:password)
    params.require(:auth).permit(:name, :password)
  end
end
