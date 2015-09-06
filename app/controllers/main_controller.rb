class MainController < ApplicationController	
	layout 'main_layout'	
	
  def index  	
    @current_user_collections = if signed_in?
      (
      Collection.where(user_id: current_user).map do |collection|
        [collection.name, collection.id]
      end
      )
    end

  	render "index", :locals => { :ismypage => false }
  end  

  def mypage
    redirect_to action: "list_likes"
  end

  def list_likes
    @current_user_collections = if signed_in?
      (
      Collection.where(user_id: current_user).map do |collection|
        [collection.name, collection.id]
      end
      )
    end

    @ajax_path = "/main/mylikes"
    render "index", :locals => { :ismypage => true }
  end

  def list_collections
    @current_user_collections = if signed_in?
      (
      Collection.where(user_id: current_user).map do |collection|
        [collection.name, collection.id]
      end
      )
    end

    @ajax_path = "/main/mycollections"
    render "index", :locals => { :ismypage => true }
  end

  def show
  end

  def mylikes
    if signed_in?
      likes = Like
      .paginate(page: params[:page], per_page: 10)
      .where("user_id = '#{current_user.id}'")
      
      @videos = Array.new
      likes.each do |like|
        @videos.push(like.video)
      end
      @counts = @videos.count

      @json = {:videos => @videos, :count => @counts}.to_json    

      render :json => @json   
    else
      render :json => {:errors => "Login to view this video"}
    end
  end

  def mycollections
    if signed_in?
      collections = Collection
      .paginate(page: params[:page], per_page: 10)
      .where("user_id = '#{current_user.id}'")

      @counts = collections.count

      @json = {:collections => collections, :count => @counts}.to_json

      render :json => @json
    else
      render :json => {:errors => "Login to view this video"}
    end
  end
  
end
