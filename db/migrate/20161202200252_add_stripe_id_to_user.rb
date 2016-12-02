class AddStripeIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_id, :string
    add_index :users, :stripe_id
  end
end