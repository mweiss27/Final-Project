class MakeRsvpUserUnique < ActiveRecord::Migration[5.0]
  def change
		add_index :rsvps, :user_id, :unique => true
  end
end
