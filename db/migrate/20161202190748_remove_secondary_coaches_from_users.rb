class RemoveSecondaryCoachesFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :secondary_coaches, :text
  end
end
