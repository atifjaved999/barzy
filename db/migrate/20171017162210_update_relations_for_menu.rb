class UpdateRelationsForMenu < ActiveRecord::Migration[5.1]
  def change
    rename_column :product_categories, :bar_id, :menu_id
    remove_column :products, :menu_id, :integer
  end
end
