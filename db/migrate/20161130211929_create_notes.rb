class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :coach_id
      t.text :body

      t.timestamps
    end
    add_index :notes, :user_id
    add_index :notes, :coach_id
  end
end
