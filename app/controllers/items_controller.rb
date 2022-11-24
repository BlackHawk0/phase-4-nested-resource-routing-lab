class ItemsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :item_not_found

  def index
    
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end

  private

  def item_not_found
    render json: {errors: "Item not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
