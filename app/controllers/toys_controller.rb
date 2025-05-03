class ToysController < ApplicationController
  before_action :set_toy, only: [ :update, :destroy ]

  api :GET, "/toys", "List all toys"
  def index
    render json: Toy.all
  end

  api :POST, "/toys", "Create a toy"
  param :name, String, desc: "Toy name", required: true
  param :value, String, desc: "Toy value", required: true
  def create
    toy = Toy.new toy_params
    toy.save!
    render json: toy
  end

  api :PATCH, "/toys/:id", "Update a toy"
  param :id, String, desc: "Toy ID", required: true
  param :name, String, desc: "Toy name", required: false
  param :value, String, desc: "Toy value", required: false
  def update
    if @toy.update(toy_params)
      render json: @toy
    else
      render json: { errors: @toy.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, "/toys/:id", "Delete a toy"
  param :id, String, desc: "Toy ID", required: true
  def destroy
    begin
      @toy.destroy
      head :no_content
    rescue ActiveRecord::InvalidForeignKey => ex
      puts ex
      raise ActionController::BadRequest.new("It is not possible to delete toys with purchase information in the system.")
    end
  end

  private

  def set_toy
    @toy = Toy.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Toy not found" }, status: :not_found
  end

  def toy_params
    params.require(:toy).permit(:name, :value)
  end
end
