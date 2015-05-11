#require 'google/api_client'


def create_new_video(video)
  new_video = Video.new
  # new_video.url = video.
  puts "\t" + video["snippet"]["title"]
  new_video.youtube_id = video["id"]
  new_video.title_korean = video["snippet"]["title"]
  new_video.description = video["snippet"]["description"]
  new_video.thumbnail = video["snippet"]["thumbnails"]["medium"]["url"]

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
  http = Curl.get(url)

  JSON.parse(http.body_str)
end

youtube_ids = ENV["YOUTUBE_IDS"].split(",")
#youtube_ids = ["smtown"]

DEVELOPER_KEY = ENV["YOUTUBE_KEY"]

def get_user_upload_video_ids(upload_channel, next_page_token)
  next_page_token = nil if next_page_token == "init"

  video_ids = youtube_api("playlistItems", { playlistId: upload_channel,
                                             part: 'contentDetails',
                                             pageToken: next_page_token,
                                             maxResults: 50 })
  nextPageToken = video_ids["nextPageToken"]

  video_ids = video_ids["items"].map do |item|
    item["contentDetails"]["videoId"]
  end

  { nextPageToken: nextPageToken, video_ids: video_ids }
end

def get_user_upload_channel_id(entertainment)
  channels = youtube_api("channels", {
    part: "contentDetails",
    forUsername: entertainment,
    maxResults: 50
  })
  channels["items"].first["contentDetails"]["relatedPlaylists"]["uploads"]
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
      puts entertainment
      user_upload_channel = get_user_upload_channel_id(entertainment)

      next_page_token = "init"

      page = 0
      until next_page_token.nil? do
        page += 1
        puts "Page: #{page}"
        video_ids = get_user_upload_video_ids(user_upload_channel, next_page_token)
        video_details = get_video_details(video_ids[:video_ids])
        next_page_token= video_ids[:nextPageToken]

        video_details.each do |video|
          unless create_new_video(video)
            next_page_token = nil # stop going to the next page
            break
          end
        end
      end

    end
  end
end
