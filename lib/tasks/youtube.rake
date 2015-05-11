#require 'google/api_client'


def create_new_video(video, youtube_user_id)
  new_video = Video.new
  puts "\t" + video["snippet"]["title"]
  new_video.youtube_id = video["id"]
  new_video.title_korean = video["snippet"]["title"]
  new_video.description = video["snippet"]["description"]
  new_video.thumbnail = video["snippet"]["thumbnails"]["medium"]["url"]
  new_video.upvotes = video["statistics"]["likeCount"]
  new_video.downvotes = video["statistics"]["dislikeCount"]
  new_video.youtube_views = video["statistics"]["viewCount"]
  new_video.youtube_user_id = youtube_user_id
  new_video.upload_date = video["snippet"]["publishedAt"]

  new_video.save
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

  begin
    channels["items"].first["contentDetails"]["relatedPlaylists"]["uploads"]
  rescue
    nil
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
      puts entertainment
      user_upload_channel = get_user_upload_channel_id(entertainment)

      unless user_upload_channel.nil?
        next_page_token = "init"

        page = 0
        until next_page_token.nil? do
          page += 1
          puts "#{entertainment} Page: #{page}"

          video_ids = get_user_upload_video_ids(user_upload_channel, next_page_token)
          video_details = get_video_details(video_ids[:video_ids])
          next_page_token= video_ids[:nextPageToken]

          video_details.each do |video|
            unless create_new_video(video, entertainment)
              next_page_token = nil # stop going to the next page
              puts "Page crawled before. Continuing to the next Youtube user id."
              break
            end
          end
        end
      end
    end
  end
end
