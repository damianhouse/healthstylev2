class AddAvatarContentTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_content_type, :string
  end
end
