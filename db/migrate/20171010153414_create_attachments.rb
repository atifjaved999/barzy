class CreateAttachments < ActiveRecord::Migration[5.1]

  def change
    create_table :attachments do |t|

      t.integer :parent_id
      t.string  :parent_type
      t.string  :token      
      t.string  :file, null: false
      t.string  :file_name
      t.integer :file_size
      t.string  :file_type
      t.string  :role

      t.timestamps null: false
    end
  end

end
