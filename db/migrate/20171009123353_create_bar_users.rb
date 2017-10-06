class CreateBarUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :bar_users do |t|
      t.integer :bar_id
      t.integer :user_id

      t.timestamps
    end
  end
end
