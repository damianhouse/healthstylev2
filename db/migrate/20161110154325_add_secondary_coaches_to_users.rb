class AddSecondaryCoachesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :secondary_coaches, :text
  end
end
