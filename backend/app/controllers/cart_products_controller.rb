class CartProductsController < ApplicationController
  before_action :find_cart, only: [:create]
  before_action :find_cart_product, only: [:update, :destroy]
  before_action :validate_quantity, only: [:create, :update]

  def create
    product = Product.find_by(product_code: params[:product_code])
    return render_error("Product not found", :not_found) unless product

    cart_product = @cart.cart_products.find_or_initialize_by(product: product)
    cart_product.quantity += @quantity

    if cart_product.save
      render json: { message: "Product added to cart" }, status: :created
    else
      render json: { errors: cart_product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @cart_product.update(quantity: @quantity)
      render json: { message: "Product quantity updated" }, status: :ok
    else
      render json: { errors: @cart_product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @cart_product.destroy
    render json: { message: "Product removed from cart" }, status: :ok
  end

  private

  def find_cart
    @cart = Cart.find_by(id: params[:cart_id])
    render_error("Cart not found", :not_found) unless @cart
  end

  def find_cart_product
    @cart_product = CartProduct.find_by(id: params[:id])
    render_error("CartProduct not found", :not_found) unless @cart_product
  end

  def validate_quantity
    @quantity = params[:quantity].to_i
    render_error("Invalid quantity", :unprocessable_entity) if @quantity <= 0
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
