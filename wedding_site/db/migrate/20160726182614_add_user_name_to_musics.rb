class AddUserNameToMusics < ActiveRecord::Migration[5.0]
  def change
    add_remove :musics, :User, :string
    add_remove :musics, :name, :string
  end
end
