class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :enter
      t.integer :open
      t.integer :cancel
      t.integer :rescan
      t.integer :result_print
      t.timestamps
    end
  end
end
