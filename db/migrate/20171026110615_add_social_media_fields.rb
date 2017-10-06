class AddSocialMediaFields < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :social_id, :string
    add_column :users, :social_email, :string
    add_column :users, :social_media, :string
  end
end
