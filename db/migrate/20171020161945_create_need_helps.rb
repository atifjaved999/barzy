class CreateNeedHelps < ActiveRecord::Migration[5.1]
  def change
    create_table :need_helps do |t|
      t.string :email
      t.text :description

      t.timestamps
    end
  end
end
