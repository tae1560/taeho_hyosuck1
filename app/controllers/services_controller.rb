class ServicesController < ApplicationController

  def home

  end

  # admin part
  def statistics
    if request.method == "POST"
      Statistic.reset
    end
  end

  def management
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

  end


  # user part
  def scan

  end

  def processing

  end

  def result
    @result =  Result.find_by_number("1")
  end
end
