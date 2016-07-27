class AddGuestSpecificChoice < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :guest_specific, :integer
  end
end
