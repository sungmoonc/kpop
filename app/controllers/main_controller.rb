class MainController < ApplicationController
  def index
  	@videos = Video.order(youtube_views: :desc).first(50)
  end

  def index2

  end

  def show
  end
end
