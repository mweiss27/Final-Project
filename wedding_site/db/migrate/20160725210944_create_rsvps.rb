class CreateRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :rsvps do |t|
    	t.integer :user #Foreign key for User

      t.timestamps
    end

    add_column :users, :rsvp, :integer #Foreign key for RSVP
    add_column :guests, :rsvp, :integer #Foreign key from guest to RSVP
  end
end
