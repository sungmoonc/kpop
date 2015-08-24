class MainController < ApplicationController	
	layout 'main_layout'	
	
  def index  	
  	render "index", :locals => { :ismypage => false }
  end  

  def mypage
  	render "index", :locals => { :ismypage => true }
  end

  def show
  end

  def mylikes
    if signed_in?
      likes = Like
      .paginate(page: params[:page], per_page: 10)
      .where("user_id = '#{current_user.id}'")
     
      render :json => likes    
    else
      render :json => {:errors => "Login to view this video"}
    end
  end
  
end
