class AddSecondaryCoachToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :secondary_coach, :integer
    add_index :users, :secondary_coach
  end
end
