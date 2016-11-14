class AddPhilosophyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :philosophy, :text
  end
end
