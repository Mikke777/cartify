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

  def add_product
    cart = Cart.find(params[:id])
    product = Product.find_by(product_code: params[:product_code])

    if product
      cart_product = cart.cart_products.find_or_initialize_by(product: product)
      cart_product.quantity += params[:quantity].to_i
      cart_product.save
      render json: { message: "Product added to cart" }, status: :ok
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  def total_price
    cart = Cart.find(params[:id])
    calculator = PricingCalculator.new(cart)
    render json: { total_price: calculator.total_price }, status: :ok
  end
end
