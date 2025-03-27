require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should validate_presence_of(:product_code) }
    it { should validate_uniqueness_of(:product_code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end
end
