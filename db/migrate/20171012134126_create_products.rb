class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :product_category_id
      t.integer :menu_id

      t.timestamps
    end
  end
end
