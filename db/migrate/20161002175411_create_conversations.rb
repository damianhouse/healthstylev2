class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :user_id, index: true
      t.integer :coach_id, index: true

      t.timestamps
    end
  end
end
