class PricingCalculator
  def initialize(cart)
    @cart = cart
  end

  def total_price
    total = 0

    @cart.cart_products.each do |cart_product|
      product = cart_product.product
      quantity = cart_product.quantity

      case product.product_code
      when "GR1"
        total += (quantity / 2 + quantity % 2) * product.price
      when "SR1"
        total += quantity >= 3 ? quantity * 450 : quantity * product.price
      when "CF1"
        discounted_price = (product.price * 2 / 3.0).round(2)
        total += quantity >= 3 ? (quantity * discounted_price).round : quantity * product.price
      else
        total += quantity * product.price
      end
    end

    (total / 100.0).round(2)
  end
end
