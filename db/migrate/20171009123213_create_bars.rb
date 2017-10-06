class CreateBars < ActiveRecord::Migration[5.1]
  def change
    create_table :bars do |t|
      t.string :name
      t.text :address
      t.string :contact_no
      t.string :website
      t.string :ratings
      t.string :price_range

      t.timestamps
    end
  end
end
