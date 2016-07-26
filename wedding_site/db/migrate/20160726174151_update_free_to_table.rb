class UpdateFreeToTable < ActiveRecord::Migration[5.0]
  def change
    change_column :tables, :free, :integer, :null => false, :default => 8
  end
end
