class CooksController < ApplicationController
  before_action :check_title_params, only: :dish

	def show
		@cook = Cook.find(params[:id])
	end

	def search
		@cook = Cook.new
	end

	def dish
		@cook = Cook.new(cook_params)

    response = send_request_to_api

    @data = JSON.parse(response.body)
    
    unless check_data_exist?
      flash[:danger] = "查询不到#{@cook.title}这道菜，换个菜名吧！"
      render :search and return
    end
    
    @first_cook_data = @data["result"]["data"][0]
    @cook.update( :burden      => @first_cook_data["burden"],
                  :title       => @first_cook_data["title"],
                  :ingredients => @first_cook_data["ingredients"])
    making_steps
	end

	private

	def cook_params
		params.require(:cook).permit(:title)
	end

  def check_title_params
    unless params[:cook][:title].present?
      flash[:danger] = "你没有输入任何菜名，请重新输入"
      @cook = Cook.new
      render :search
    end
  end

  def send_request_to_api
    RestClient.get "http://apis.juhe.cn/cook/query.php", 
                   :params => { :menu => @cook.title , :key => ENV["api_key"] }
  end

  def check_data_exist?
    !@data["result"].nil? 
  end

  def making_steps
    @steps = Array.new()
    @first_cook_data["steps"].each do |s|
      @steps  <<  s["step"]  
    end
  end

end
