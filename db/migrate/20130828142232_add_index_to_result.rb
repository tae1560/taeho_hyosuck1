class AddIndexToResult < ActiveRecord::Migration
  def change
    add_index :results, :number, :unique => true
  end
end
