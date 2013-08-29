# coding: utf-8
class ServicesController < ApplicationController

  def home

  end

  # admin part
  def statistics
    #session[:password] = nil
    unless SampleUser.is_authenticated session
      redirect_to "/authenticate?url=statistics"
    end

    if request.method == "POST"
      Statistic.reset
    end
  end

  def management
    unless SampleUser.is_authenticated session
      redirect_to "/authenticate?url=management"
    end

    if params["number"]
      unless Result.find_by_number(params["number"])
        params["number"] = "1"
      end
    else
      params["number"] = "1"
    end

    @result =  Result.find_by_number(params["number"])


    if params[:password]
      # password change
      SampleUser.change_password params[:password]
      flash[:notice] = "password changed"
    elsif params[:text1]
      # data change

      @result.text1 = params[:text1]
      @result.text2 = params[:text2]

      if params["result"]["image1"]
        @result.image1 = params["result"]["image1"]
      end
      if params["result"]["image2"]
        @result.image2 = params["result"]["image2"]
      end

      @result.save!
    end

  end

  def authenticate
    if params[:password] and SampleUser.auth params[:password]
      if params[:url] and params[:url].length > 0
        url = params[:url]
        SampleUser.after_auth session
        redirect_to "/" + url
      end
    end
  end


  # user part
  def scan
    Statistic.on_enter
  end

  def processing

  end

  def result
    @error_messages = []
    # validates

    # date : 01~31
    unless params["date"].to_i >= 1 and params["date"].to_i <= 31
      @error_messages.push "date가 잘못 입력되었습니다."
    end

    unless params["month"].to_i >= 1 and params["month"].to_i <= 12
      @error_messages.push "month가 잘못 입력되었습니다."
    end

    unless params["year"].to_i >= 1800 and params["year"].to_i <= 2500
      @error_messages.push "year가 잘못 입력되었습니다."
    end

    unless params["name"].length >= 1
      @error_messages.push "이름을 입력해 주세요"
    end

    unless params["gender"]
      @error_messages.push "성별을 선택해주세요"
    end

    if !params["category"]
      @error_messages.push "catogory를 선택해주세요"
    elsif params["category"] == "REGULAR"
      unless params["blood_type"]
        @error_messages.push "혈액형을 선택해주세요"
      end
    end



    unless @error_messages.count > 0
      # save
      #params["processing"]["scan_image"]
      @processing = Processing.new
      @processing.year = params["year"].to_i
      @processing.month = params["month"].to_i
      @processing.day = params["date"].to_i
      @processing.name = params["name"]
      @processing.gender = params["gender"]
      @processing.blood_type = params["blood_type"]
      @processing.category = params["category"]
      @processing.data_type = params["data_type"]
      if params["processing"] and params["processing"]["scan_image"]
        @processing.scan_image = params["processing"]["scan_image"]
      end
      if @processing.save
        @result =  Result.find_by_data @processing.month, @processing.day, @processing.blood_type, @processing.category
      end
    end

    #{"date"=>"", "month"=>"", "year"=>"", "name"=>"", "gender"=>"MALE", "blood_type"=>"A", "category"=>"REGULAR", "data_type"=>"LEFT HAND", "x"=>"32", "y"=>"41", "action"=>"result", "controller"=>"services"}
  end


end
