class Result < ActiveRecord::Base
  attr_accessible :number, :start_month, :start_day, :end_month, :end_day, :blood_type, :category,
                  :text1, :text2, :image1, :image2
  has_attached_file :image1
  has_attached_file :image2

  def self.find_by_data month, day, blood_type, category
    results = Result.filter_by_category_and_blood_type blood_type, category
    # TODO 연도 넘어가는 것 고려
    #result = results.where("('start_month' = #{month} AND 'start_day' <= #{day}) OR 'start_month' = #{month} ")
    # 1.20 ~ 2.22
    # 12.21 ~ 1.19

    target_date = "2013-#{month}-#{day}".to_date
    results.find_each do |result|
      start_date = "2013-#{result.start_month}-#{result.start_day}".to_date
      end_date = "2013-#{result.end_month}-#{result.end_day}".to_date

      if start_date > end_date
      #   연도가 넘어가는 경우
        end_date += 1.year

        if start_date <= target_date and target_date <= end_date
          return result
        end

        start_date -= 1.year
        end_date -= 1.year
      end

      if start_date <= target_date and target_date <= end_date
        return result
      end
    end
  end

  def self.filter_by_category_and_blood_type blood_type, category
    #  blood_type => a/b/ab/o (regular)
    #  category => regular infants child check
    results = Result.where(:category => category)
    if "REGULAR" == category
      results = results.where(:blood_type => blood_type)
    end
    return results
  end

    def two_digit_number
    if self.number < 10
      "0#{self.number}"
    else
      "#{self.number}"
    end
  end
end
