require "rails_helper"

RSpec.describe PricingCalculator do
  let(:cart) { Cart.create }
  let(:green_tea) { Product.create(product_code: "GR1", name: "Green Tea", price: 311) }
  let(:strawberries) { Product.create(product_code: "SR1", name: "Strawberries", price: 500) }
  let(:coffee) { Product.create(product_code: "CF1", name: "Coffee", price: 1123) }

  describe "#total_price" do
    it "applies buy-one-get-one-free for Green Tea" do
      cart.cart_products.create(product: green_tea, quantity: 2)
      calculator = PricingCalculator.new(cart)
      expect(calculator.total_price).to eq(3.11)
    end

    it "applies bulk discount for Strawberries" do
      cart.cart_products.create(product: strawberries, quantity: 3)
      calculator = PricingCalculator.new(cart)
      expect(calculator.total_price).to eq(13.50)
    end

    it "applies bulk discount for Coffee" do
      cart.cart_products.create(product: coffee, quantity: 3)
      calculator = PricingCalculator.new(cart)
      expect(calculator.total_price).to eq(22.46)
    end

    it "calculates the total price for a mixed cart" do
      cart.cart_products.create(product: green_tea, quantity: 2)
      cart.cart_products.create(product: strawberries, quantity: 3)
      cart.cart_products.create(product: coffee, quantity: 3)
      calculator = PricingCalculator.new(cart)
      expect(calculator.total_price).to eq(39.07)
    end
  end
end
