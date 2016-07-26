class AddResponseForRsvp < ActiveRecord::Migration[5.0]
  def change
  	add_column :rsvps, :response, :integer
  end
end
