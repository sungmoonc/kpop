class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
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
    @videos = Video.first(100)
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

  def filters
    integer_filters = get_range_filters("hotness", "cheesiness", "english_percentage")
    boolean_filters = get_boolean_filters("english_subtitle", "official", "licensed_content")
    category = "category = '#{params[:category]}'" unless params[:category] == "all"

    @videos = Video
      .paginate(page: params[:page], per_page: 10)
      .where(integer_filters.join(" and "))
      .where(boolean_filters)
      .where(category)
      .order("#{params[:sort]} desc")

    render json: @videos
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  def get_range_filters(*filters)
    filters.map do |filter|
      "#{filter} >= #{params[filter][:min]} and #{filter} <= #{params[filter][:max]}"
    end
  end

  def get_boolean_filters(*filters)
    output = {}
    filters.select do |filter|
      params[filter] == "on"
    end.each do |filter|
      output[filter] = true
    end
    output
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def video_params
    params.require(:video).permit(:youtube_id, :thumbnail, :artist, :title_korean, :title_english, :youtube_user_id, :description, :hotness, :cheesiness, :english_percentage, :english_subtitle, :official, :youtube_views, :definition, :duration, :dimension, :caption, :category, :licensed_content, :upload_date, :upvotes, :downvotes)
  end
end
