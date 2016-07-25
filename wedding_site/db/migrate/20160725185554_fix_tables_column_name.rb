class FixTablesColumnName < ActiveRecord::Migration[5.0]
  def change
    change_table :tables do |t|
      t.rename :e1, :guest1_id
      t.rename :e2, :guest2_id
      t.rename :e3, :guest3_id
      t.rename :e4, :guest4_id
      t.rename :e5, :guest5_id
      t.rename :e6, :guest6_id
      t.rename :e7, :guest7_id
      t.rename :e8, :guest8_id
    end
  end
end
