class AddUserPhotoPermission < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :agreed_to_photos, :boolean
  end
end
