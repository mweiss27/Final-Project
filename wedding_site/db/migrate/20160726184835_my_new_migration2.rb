class MyNewMigration2 < ActiveRecord::Migration[5.0]
  def change
	add_column :musics, :requestName, :string
  end
end
