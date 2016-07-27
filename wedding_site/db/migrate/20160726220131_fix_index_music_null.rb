class FixIndexMusicNull < ActiveRecord::Migration[5.0]
  def change
	change_column :musics, :band, :track, :null=>false
  end
end
