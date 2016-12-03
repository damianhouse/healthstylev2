class AddPrimaryCoachToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :primary_coach, :integer
    add_index :users, :primary_coach
  end
end
