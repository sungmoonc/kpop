class MainController < ApplicationController
	layout "main_layout"
	
  def index
  	# @videos = Video.order(youtube_views: :desc).first(50)
  end  

  def show
  end
end
