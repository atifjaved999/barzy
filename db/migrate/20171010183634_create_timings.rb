class CreateTimings < ActiveRecord::Migration[5.1]
  def change
    create_table :timings do |t|
      t.string :day
      t.time :opening_time
      t.time :closing_time
      t.integer :bar_id

      t.timestamps
    end
  end
end
