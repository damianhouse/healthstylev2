class AddPrimaryCoachToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :primary_coach, :integer
  end
end
