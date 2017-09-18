class CooksController < ApplicationController

	def show
		@cook = Cook.find(params[:id])
	end

	def new
		@cook = Cook.new
	end

	def create
		@cook = Cook.new(cook_params)

    response = RestClient.get "http://apis.juhe.cn/cook/query.php", 
                              :params => { :menu => @cook.title , :key => ENV["api_key"] }
    @data = JSON.parse(response.body)
    
    unless dish_exist？
      flash.now[:warning] = "查询不到#{@cook.title},请核实你的菜名！"
      render :new and return
    end 
    @cook.update( :burden => @data["result"]["data"][0]["burden"],
                  :title => @data["result"]["data"][0]["title"],
                  :ingredients => @data["result"]["data"][0]["ingredients"])
    @cook.steps = []
    @data["result"]["data"][0]["steps"].each do |d|
    	@cook.steps  +=  d["step"]    	
    end

		@cook.save
		redirect_to cook_path(@cook)

	end

	private

	def cook_params
		params.require(:cook).permit(:title)
	end

  def dish_exist？
    !@data["result"].nil? 
  end

end
