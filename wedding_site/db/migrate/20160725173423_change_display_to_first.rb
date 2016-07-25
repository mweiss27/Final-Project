class ChangeDisplayToFirst < ActiveRecord::Migration[5.0]
  def change
	rename_column :users, :display_name, :first_name
	add_column :users, :last_name, :string
  end
end
