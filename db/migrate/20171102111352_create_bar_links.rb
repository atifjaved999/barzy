class CreateBarLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :bar_links do |t|
      t.string :name
      t.string :link
      t.string :zip_code
      t.timestamps
    end
  end
end
