class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :product_code
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
