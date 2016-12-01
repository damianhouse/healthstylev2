class AddAvatarFileNameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_file_name, :string
  end
end
