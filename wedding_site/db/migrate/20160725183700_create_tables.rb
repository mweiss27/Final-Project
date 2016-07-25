class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :tables do |t|
      t.integer :e1
      t.integer :e2
      t.integer :e3
      t.integer :e4
      t.integer :e5
      t.integer :e6
      t.integer :e7
      t.integer :e8
      t.integer :free

      t.timestamps
    end
  end
end
