class FixIndexMusic < ActiveRecord::Migration[5.0]
  def change
	add_index :musics, ["band","track"], :unique=>true
  end
end
