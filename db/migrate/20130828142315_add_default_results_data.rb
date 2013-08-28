class AddDefaultResultsData < ActiveRecord::Migration
  def self.up
    ranges = [[1,20,2,18], [2,19,3,20], [3,21,4,19], [4,20,5,20],
     [5,21,6,21], [6,22,7,22], [7,23,8,22], [8,23,9,23],
     [9,24,10,22], [10,23,11,22],[11,23,12,24],[12,25,1,19]]

    categories = [["A", "REGULAR"],["B", "REGULAR"],["AB", "REGULAR"],["O", "REGULAR"],[nil, "INFANTS"],[nil, "CHILD"]]

    index = 1
    categories.each do |category|
      ranges.each do |range|
        result = Result.create(:number => index,
                      :start_month => range[0],
                      :start_day => range[1],
                      :end_month => range[2],
                      :end_day => range[3],
                      :blood_type => category[0],
                      :category => category[1])

        index += 1

        puts result.inspect
      end
    end
  end

  def self.down
    Result.delete_all
  end
end
