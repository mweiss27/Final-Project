class FixIdColumns < ActiveRecord::Migration[5.0]
  def change
  	rename_column :guests, :user, :user_id
  	rename_column :users, :rsvp, :rsvp_id
  	rename_column :guests, :rsvp, :rsvp_id
  end
end
