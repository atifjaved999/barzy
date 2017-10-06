class CreateBusinessInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :business_infos do |t|
      t.string :name
      t.string :value
      t.string :bar_id

      t.timestamps
    end
  end
end
