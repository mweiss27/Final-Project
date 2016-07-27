class MyNewMigration < ActiveRecord::Migration[5.0]
  def change
    remove_column :musics, :name, :string
  end

end

