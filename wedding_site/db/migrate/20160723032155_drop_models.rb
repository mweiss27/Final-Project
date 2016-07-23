class DropModels < ActiveRecord::Migration[5.0]
  def change
  	drop_table :models if ActiveRecord::Base.connection.table_exists? :models
  end
end
