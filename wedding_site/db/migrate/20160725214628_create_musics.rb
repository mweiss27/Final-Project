class CreateMusics < ActiveRecord::Migration[5.0]
  def change
    create_table :musics do |t|
      t.string :band
      t.string :track

      t.timestamps
    end
  end
end
