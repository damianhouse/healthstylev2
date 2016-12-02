class AddTertiaryCoachToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tertiary_coach, :integer
    add_index :users, :tertiary_coach
  end
end
