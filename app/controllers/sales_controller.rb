class SalesController < ApplicationController
  before_action :set_sale, only: [:update, :destroy]

  api :GET, '/sales', 'List all sales with optional filters by date'
  param :date, String, desc: 'Filter by date (ex: 2020-05-01)', required: false
  def index
    render json: SalesService.get_sales_by_date(params[:date])
  end

  api :POST, '/sales', 'Create a sale'
  param :client_id, String, desc: 'Sale client_id', required: true
  param :toy_id, String, desc: 'Sale toy_id', required: true
  def create
    sale = Sale.new sale_params
    sale.save!
    render json: sale
  end

  api :PATCH, '/sales/:id', 'Update a sale'
  param :id, String, desc: 'Sale ID', required: true
  param :client_id, String, desc: 'Sale client_id', required: false
  param :toy_id, String, desc: 'Sale toy_id', required: false
  def update
    if @sale.update(sale_params)
      render json: @sale
    else
      render json: { errors: @sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  api :DELETE, '/sales/:id', 'Delete a sale'
  param :id, String, desc: 'Sale ID', required: true
  def destroy
    @sale.destroy
    head :no_content
  end

  api :GET, '/sales/higher/volume', 'The clients with the highest sales volume'
  def get_higher_volume_sale
    render json: SalesService.get_higher_volume
  end

  api :GET, '/sales/higher/average', 'The clients with the highest sales average'
  def get_highest_average_amount_sale
    render json: SalesService.get_highest_average_amount
  end

  api :GET, '/sales/higher/frequency', 'The clients with the highest sales frequency'
  def get_highest_frequency_sale
    render json: SalesService.get_highest_frequency
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Sale not found' }, status: :not_found
  end

  def sale_params
    params.require(:sale).permit(:client_id, :toy_id)
  end

end
