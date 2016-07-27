class RemoveFieldNameFromMusic < ActiveRecord::Migration[5.0]
  def change
    remove_column :musics, :User, :string
  end
end
