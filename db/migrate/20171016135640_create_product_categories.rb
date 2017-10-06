class CreateProductCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.text :description
      t.integer :bar_id

      t.timestamps
    end
  end
end
