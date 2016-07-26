class CreateAccommodations < ActiveRecord::Migration[5.0]
  def change
    create_table :accommodations do |t|
    	t.string :name
      t.timestamps
    end
  end
end
