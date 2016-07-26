class FixMoreIds < ActiveRecord::Migration[5.0]
  def change
  	rename_column :rsvps, :user, :user_id
  end
end
