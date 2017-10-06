class AddLocationFieldsToBars < ActiveRecord::Migration[5.1]
  def change
    add_column :bars, :lat, :float
    add_column :bars, :lng, :float

  end
end
