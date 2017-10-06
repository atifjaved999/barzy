class AddDescriptionToBars < ActiveRecord::Migration[5.1]
  def change
    add_column :bars, :description, :string
  end
end
