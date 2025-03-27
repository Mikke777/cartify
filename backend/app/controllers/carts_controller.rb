class CartsController < ApplicationController
  def index
    carts = Cart.all
    render json: carts
  end

  def show
    cart = Cart.find(params[:id])
    render json: cart, include: :cart_products
  end

  def create
    cart = Cart.create
    render json: { id: cart.id }, status: :created
  end

  def total_price
    cart = Cart.find(params[:id])
    calculator = PricingCalculator.new(cart)
    render json: { total_price: calculator.total_price }, status: :ok
  end
end
