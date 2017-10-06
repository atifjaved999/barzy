class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :description
      t.integer :bar_id

      t.timestamps
    end
  end
end
