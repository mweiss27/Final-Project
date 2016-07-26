class MoveTableIdFromGuestsToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :table_id, :integer
    remove_column :guests, :table_id
  end
end
