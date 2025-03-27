require 'rails_helper'

RSpec.describe "CartProducts", type: :request do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, product_code: "GR1", name: "Green Tea", price: 300) }
  let!(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 1) }

  let(:cart_products_path) { "/carts/#{cart.id}/cart_products" }
  let(:cart_product_path) { "#{cart_products_path}/#{cart_product.id}" }

  shared_examples "not found error" do |message|
    it "returns a 404 error" do
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include(message)
    end
  end

  describe "POST /carts/:cart_id/cart_products" do
    context "when the product exists" do
      it "adds the product to the cart" do
        post cart_products_path, params: { product_code: "GR1", quantity: 2 }

        expect(response).to have_http_status(:created)
        expect(cart.cart_products.count).to eq(1)
        expect(cart.cart_products.first.quantity).to eq(3)
      end
    end

    context "when the product does not exist" do
      before { post cart_products_path, params: { product_code: "INVALID", quantity: 2 } }

      include_examples "not found error", "Product not found"
    end

    context "when the cart does not exist" do
      before { post "/carts/999/cart_products", params: { product_code: "GR1", quantity: 2 } }

      include_examples "not found error", "Cart not found"
    end

    context "when the quantity is invalid" do
      it "returns a 422 error" do
        post cart_products_path, params: { product_code: "GR1", quantity: 0 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid quantity")
      end
    end
  end

  describe "PATCH /carts/:cart_id/cart_products/:id" do
    it "updates the quantity of the cart product" do
      patch cart_product_path, params: { quantity: 5 }

      expect(response).to have_http_status(:ok)
      expect(cart_product.reload.quantity).to eq(5)
    end

    context "when the cart product does not exist" do
      before { patch "#{cart_products_path}/999", params: { quantity: 5 } }

      include_examples "not found error", "CartProduct not found"
    end

    context "when the quantity is invalid" do
      it "returns a 422 error" do
        patch cart_product_path, params: { quantity: -1 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid quantity")
      end
    end
  end

  describe "DELETE /carts/:cart_id/cart_products/:id" do
    context "when the cart product exists" do
      it "removes the cart_product from the cart" do
        delete cart_product_path

        expect(response).to have_http_status(:ok)
        expect(cart.cart_products.count).to eq(0)
      end
    end

    context "when the cart product does not exist" do
      before { delete "#{cart_products_path}/999" }

      include_examples "not found error", "CartProduct not found"
    end
  end
end
