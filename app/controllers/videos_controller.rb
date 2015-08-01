class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @@is_current_user_admin = signed_in? && current_user[:admin]

    @current_user_collections = if signed_in?
      (
      Collection.where(user_id: current_user).map do |collection|
        [collection.name, collection.id]
      end
      )
    end

  end


  # GET /videos/1
  # GET /videos/1.json
  def show
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

  def save_kpop_fields
    if @@is_current_user_admin
      video = Video.find(params["video_id"])
      # todo: add model validation range 0 - 10
      video.title_korean=params["title_korean"]
      video.category=params["category"]
      video.hotness=params["hotness"]
      video.cheesiness=params["cheesiness"]

      if video.save
        head :ok
      else
        head :internal_server_error
      end
    else
      head :bad_request
    end
  end

  def add_collection
    if CollectionsVideo.create!(collection_id: params["collection_id"], video_id: params["video_id"])
      head :ok
    else
      head :internal_server_error
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

  def create_likes
    if signed_in?
      new_like = Like.new
      new_like.user_id=current_user.id
      new_like.video_id=params[:id]
      if new_like.save
        current_video = Video.find_by(id: params[:id])
        render json: current_video
      end
    else
      render :json => { :errors => "Login to like this video" }
    end
  end

  def add_to_new_collection
    collection = Collection.create!(name: params[:name], user_id: current_user.id)
    if CollectionsVideo.create!(collection_id: collection["id"], video_id: params["video_id"])
      head :ok
    else
      head :internal_server_error
    end
  end

  def filters
    search_filters = get_search_filters("title_korean", "title_english", "youtube_user_id", "description")
    integer_filters = get_range_filters(params, "hotness", "cheesiness", "english_percentage", "approval_rating")
    boolean_filters = get_boolean_filters(params, "english_subtitle", "official", "licensed_content")
    category = "category = '#{params[:category]}'" unless params[:category] == "all"
    # none0
    # collection = "category = '#{params[:category]}'" unless params[:category] == "all"

    videos = Video
      .paginate(page: params[:page], per_page: 10)
      .where(search_filters.join(" or "))
      .where(integer_filters.join(" and "))
      .where(boolean_filters)
      .where(category)
      .order("#{params[:sort]} desc")

    # unless params[:collection] == "none0"
    #   video_ids = CollectionsVideo.where(collection_id: params[:collection].to_i).map do |v|
    #     v[:video_id]
    #   end.uniq
    #   videos = videos.where(id: video_ids)
    # end


    videos = videos.as_json.map do |video|
      video["editable"] = @@is_current_user_admin
      video["likes"] = Video.find(video["id"]).likes_count
      video
    end
    render json: videos
  end

  def filters_test     
    search_filters = get_search_filters("title_korean", "title_english", "youtube_user_id", "description")
    integer_filters = get_range_filters(params, "hotness", "cheesiness", "english_percentage", "approval_rating")
    boolean_filters = get_boolean_filters(params, "english_subtitle", "official", "licensed_content")
    category = "category = '#{params[:category]}'" unless params[:category] == "all"

    
    @videos = Video
      .paginate(page: params[:page], per_page: 20)
      .where(boolean_filters)
      .where(search_filters.join(" or ")) 
      .where(integer_filters.join(" and "))
      .where(category)                                
      .order("#{params[:sort]} desc")      
    @counts = @videos.count

    @json = {:videos => @videos, :count => @counts}.to_json    

    render json: @json
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  def get_search_filters(*filters)
    return [] if params[:search].size == 0
    filters.map do |filter|
      "#{filter} like '%#{params[:search]}%'"
    end
  end

  def get_range_filters(params, *filters)
    filters.map do |filter|
      "#{filter} >= #{params[filter][:min]} and #{filter} <= #{params[filter][:max]}"
    end
  end

  def get_boolean_filters(params, *filters)
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
    params.require(:video).permit(:youtube_id, :thumbnail, :artist, :title_korean, :title_english, :youtube_user_id, :description, :hotness, :cheesiness, :english_percentage, :english_subtitle, :official, :youtube_views, :definition, :duration, :dimension, :caption, :category, :licensed_content, :approval_rating, :upvotes_per_views, :likes, :upload_date, :upvotes, :downvotes)
  end

end
