class CreateAccomodationChoices < ActiveRecord::Migration[5.0]
  def change
  	create_table :persons do |t|
  		t.string :first_name
  		t.string :last_name
      t.timestamps
    end

    create_table :accomodation_choices do |t|
    	t.integer :person_id
    	t.integer :accomodation_id
      t.timestamps
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :person_id, :integer
    add_column :guests, :person_id, :integer #Guests will have both user and person. They belong to a user, they are a person
  end
end
