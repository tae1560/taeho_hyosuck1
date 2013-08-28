class CreateSampleUsers < ActiveRecord::Migration
  def change
    create_table :sample_users do |t|
      t.string :password
      t.timestamps
    end
  end
end
