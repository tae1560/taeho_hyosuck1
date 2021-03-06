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

      if params["result"] and params["result"]["image1"]
        @result.image1 = params["result"]["image1"]
      end
      if params["result"] and params["result"]["image2"]
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
    @error_messages = []
    # validates

    # date : 01~31
    unless params["date"] and params["date"].to_i >= 1 and params["date"].to_i <= 31
      @error_messages.push "date가 잘못 입력되었습니다."
    end

    unless params["month"] and params["month"].to_i >= 1 and params["month"].to_i <= 12
      @error_messages.push "month가 잘못 입력되었습니다."
    end

    unless params["year"] and params["year"].to_i >= 1800 and params["year"].to_i <= 2500
      @error_messages.push "year가 잘못 입력되었습니다."
    end

    unless params["name"] and params["name"].length >= 1
      @error_messages.push "이름을 입력해 주세요"
    end

    unless params["gender"]
      @error_messages.push "성별을 선택해주세요"
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

    unless params["processing"] and params["processing"]["scan_image"]
      @error_messages.push "SCAN IMAGE를 입력해주세요."
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
        #@result =  Result.find_by_data @processing.month, @processing.day, @processing.blood_type, @processing.category
      end
    end
  end

  def result
    @processing = Processing.find_by_id(params[:id])
    if(@processing)
      @result =  Result.find_by_data @processing.month, @processing.day, @processing.blood_type, @processing.category
    end

    #{"date"=>"", "month"=>"", "year"=>"", "name"=>"", "gender"=>"MALE", "blood_type"=>"A", "category"=>"REGULAR", "data_type"=>"LEFT HAND", "x"=>"32", "y"=>"41", "action"=>"result", "controller"=>"services"}
  end

  def result_print
    @processing = Processing.find_by_id(params[:id])
    if(@processing)
      @result =  Result.find_by_data @processing.month, @processing.day, @processing.blood_type, @processing.category
    end
  end

  def api
    if params[:event]
      if params[:event] == "enter"
        Statistic.on_enter
      elsif params[:event] == "rescan"
        Statistic.on_rescan
      elsif params[:event] == "print"
        Statistic.on_print
      elsif params[:event] == "cancel"
        Statistic.on_cancel
      elsif params[:event] == "open"
        Statistic.on_open
      end
    end
    render :json => "api test"
  end


end
