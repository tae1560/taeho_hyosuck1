class Processing < ActiveRecord::Base
  attr_accessible :year, :month, :day, :name, :gender, :blood_type, :category, :data_type, :scan_image
  has_attached_file :scan_image

  # validate

  def result
    Result.find_by_data month, day, blood_type, category
  end
end
