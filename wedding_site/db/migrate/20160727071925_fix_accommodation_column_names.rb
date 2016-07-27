class FixAccommodationColumnNames < ActiveRecord::Migration[5.0]
  def change
  	rename_table :accomodation_choices, :accommodation_choices
  	rename_column :accommodation_choices, :accomodation_id, :accommodation_id
  end
end
