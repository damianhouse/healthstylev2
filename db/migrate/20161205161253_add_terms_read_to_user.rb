class AddTermsReadToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :terms_read, :boolean, default: false
  end
end
