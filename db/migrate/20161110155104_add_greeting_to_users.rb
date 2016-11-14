class AddGreetingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :greeting, :text
  end
end
