FactoryBot.define do
  factory :cart_product do
    cart
    product
    quantity { 1 }
  end
end
