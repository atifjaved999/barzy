class AddFieldsToMenu < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :yelp_reference_id, :string
    add_column :menus, :external_menu_url, :string
  end
end
