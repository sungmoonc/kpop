class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.where("title_korean LIKE '%M/V%' or title_korean LIKE '%Music Video%' or title_korean LIKE '%MV%'").order("youtube_views DESC").first(100)
    # @videos = Video.where("title_korean LIKE '%teaser%' or title_korean LIKE '%티저%'").order("youtube_views DESC").first(100)
    # @videos = Video.where("title_korean LIKE '%안무%'").order("youtube_views DESC").first(100)
  end


  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #sorting

  def sort_by
    sorted = params[:field] + " " + params[:order]
    @videos = Video.order(sorted)
    render json: @videos
  end

  #filtering

  # def filter_by
  #   @videos = Video.where("#{params[:field]} >= #{params[:from]} and #{params[:field]} <= #{params[:to]}")
  #   render json: @videos
  # end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def video_params
    params.require(:video).permit(:youtube_id, :thumbnail, :artist, :title_korean, :title_english, :youtube_user_id, :description, :hotness, :cheesiness, :english_percentage, :english_subtitle, :official, :youtube_views, :definition, :duration, :dimension, :caption, :type, :licensed_content, :upload_date, :upvotes, :downvotes)
  end
end
