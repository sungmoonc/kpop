class MainController < ApplicationController
	layout "main_layout"
	
  def index  	
  	render "index", :locals => { :ismypage => false }
  end  

  def mypage
  	render "index", :locals => { :ismypage => true }
  end

  def show
  end
end
