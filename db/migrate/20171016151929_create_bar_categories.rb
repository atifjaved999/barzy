class CreateBarCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :bar_categories do |t|
      t.integer :bar_id
      t.integer :category_id

      t.timestamps
    end
  end
end
