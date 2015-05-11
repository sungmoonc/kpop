#require 'google/api_client'


def create_new_video(video)
  new_video = Video.new
  # new_video.url = video.
  new_video.youtube_id = video.snippet.resourceId.videoId
  new_video.title_korean = video.snippet.title
  new_video.description = video.snippet.description
  new_video.thumbnail = video.snippet.thumbnails["medium"]["url"]

  new_video.save
end

def get_video_ids(client, user_response, youtube)
  item = user_response.data.items.first
  pid = item.contentDetails.relatedPlaylists.uploads

  video_response = client.execute(
    :api_method => youtube.playlist_items.list,
    :parameters => {
      :playlistId => pid,
      :part => 'contentDetails',
      :maxResults => 50
    }
  )

  # page_token = video_response.next_page_token
  #
  #
  # while(true) do
  #   video_response = client.execute!(
  #       :api_method => youtube.playlist_items.list,
  #       :parameters => {
  #           :playlistId => pid,
  #           :part => 'snippet,contentDetails',
  #           :pageToken => page_token
  #       }
  #   )
  #
  # page_token = video_response.next_page_token
  #
  #   break if page_token == nil

  video_response.data.items.map do |item|
    item.contentDetails.videoId
  end
end

def youtube_api(method, options)
  options_string = options.map do |option|
    option[0].to_s + "=" + option[1].to_s
  end.join("&")

  url = "https://www.googleapis.com/youtube/v3/#{method}?" + options_string + "&key=#{DEVELOPER_KEY}"
  puts url

  http = Curl.get(url)

  JSON.parse(http.body_str)
end

youtube_ids = ENV["YOUTUBE_IDS"].split(",")
#youtube_ids = ["smtown"]

DEVELOPER_KEY = ENV["YOUTUBE_KEY"]

def get_user_videos(entertainment)
  channels = youtube_api("channels", {
    part: "contentDetails",
    forUsername: entertainment,
    maxResults: 50
  })
  upload_channel = channels["items"].first["contentDetails"]["relatedPlaylists"]["uploads"]

  video_ids = youtube_api("playlistItems", { playlistId: upload_channel,
                                             part: 'contentDetails',
                                             maxResults: 50 })
  #p  video_ids["nextPageToken"]

  video_ids["items"].map do |item|
    item["contentDetails"]["videoId"]
  end
end

def get_video_details(video_ids)
  youtube_api("videos", {
    :id => video_ids.join(","),
    :part => 'snippet,statistics',
    :maxResults => 50
  })["items"]
end

namespace :youtube do
  desc "TODO"
  task fetch: :environment do

    youtube_ids.each do |entertainment|
      video_ids = get_user_videos(entertainment)
      video_details = get_video_details(video_ids)

      p video_details

    end

  end
end
