class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :number
      t.integer :start_month
      t.integer :start_day
      t.integer :end_month
      t.integer :end_day
      t.string :blood_type
      t.string :category
      t.text :text1
      t.text :text2

      t.attachment :image1
      t.attachment :image2
      t.timestamps
    end
  end

  def self.down
    drop_attached_file :results, :image1
    drop_attached_file :results, :image2
  end
end
