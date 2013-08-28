class Result < ActiveRecord::Base
  attr_accessible :number, :start_month, :start_day, :end_month, :end_day, :blood_type, :category,
                  :text1, :text2, :image1, :image2
  has_attached_file :image1
  has_attached_file :image2

  def self.find_by_data month, day, blood_type, category
    results = Result.filter_by_category_and_blood_type blood_type, category
    # TODO 연도 넘어가는 것 고려
    #result = results.where("('start_month' = #{month} AND 'start_day' <= #{day}) OR 'start_month' = #{month} ")
  end

  def self.filter_by_category_and_blood_type blood_type, category
    #  blood_type => a/b/ab/o (regular)
    #  category => regular infants child check
    results = Result.where(:category => category)
    if "regular" == category
      results = results.where(:blood_type => blood_type)
    end
  end

    def two_digit_number
    if self.number < 10
      "0#{self.number}"
    else
      "#{self.number}"
    end
  end
end
