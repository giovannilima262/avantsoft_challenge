class ClientsController < ApplicationController
  before_action :set_client, only: [ :update, :destroy ]

  api :GET, "/clients", "List all clients with optional filters by name and email"
  param :name, String, desc: "Filter by name (partial match, case-insensitive)", required: false
  param :email, String, desc: "Filter by email (partial match, case-insensitive)", required: false
  def index
    clients = Client.all
    clients = clients.filter_name(params[:name]) if params[:name].present?
    clients = clients.filter_name(params[:email]) if params[:email].present?
    render json: clients
  end

  api :POST, "/clients", "Create a client"
  param :name, String, desc: "Client name", required: true
  param :email, String, desc: "Client email", required: true
  def create
    client = Client.new client_params
    client.save!
    render json: client
  end

  api :PATCH, "/clients/:id", "Update a client"
  param :id, String, desc: "Client ID", required: true
  param :name, String, desc: "Client name", required: false
  param :email, String, desc: "Client email", required: false
  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/clients/:id", "Delete a client"
  param :id, String, desc: "Client ID", required: true
  def destroy
    begin
      @client.destroy
      head :no_content
    rescue ActiveRecord::InvalidForeignKey => ex
      puts ex
      raise ActionController::BadRequest.new("It is not possible to delete clients with purchase information in the system.")
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Client not found" }, status: :not_found
  end

  def client_params
    params.require(:client).permit(:name, :email)
  end
end
