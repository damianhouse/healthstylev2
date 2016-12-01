class AddSecondaryUsersToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :secondary_users, :text
  end
end
