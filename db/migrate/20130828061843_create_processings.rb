class CreateProcessings < ActiveRecord::Migration
  def change
    create_table :processings do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.string :name
      t.string :gender
      t.string :blood_type
      t.string :category
      t.string :data_type
      t.attachment :scan_image
      t.timestamps
    end
  end

  def self.down
    drop_attached_file :processings, :scan_image
  end
end
